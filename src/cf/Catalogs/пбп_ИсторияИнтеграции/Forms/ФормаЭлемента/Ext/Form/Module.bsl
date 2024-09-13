﻿// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8,
// включая доработку типовых конфигураций.
//
// Copyright First BIT company
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
// URL:    https://github.com/firstBitSportivnaya/PSSL/
//

#Область ОписаниеПеременных

&НаКлиенте
Перем ДокументВнешнийОбъектИсходящий, ДокументВнешнийОбъектВходящий;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьСвойстваЭлементов();
	
	ЭтоЗагрузка = Объект.Статус = Перечисления.пбп_СтатусыИнтеграции.Загружено
		ИЛИ Объект.Статус = Перечисления.пбп_СтатусыИнтеграции.ОшибкаЗагрузки;
	Элементы.ГруппаОбъектыОбмена.Заголовок = ?(ЭтоЗагрузка, "Загруженные объекты", "Выгруженные объекты");
	
	Если НЕ Объект.Ошибка Тогда
		Элементы.ГруппаТекстОшибки.Видимость = Ложь;
		Элементы.Ошибка.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.ФорматИнтеграции <> Перечисления.пбп_ФорматыИнтеграций.ПроизвольныйФормат Тогда
		Элементы.ГруппаФорматированиеТекстаЗапроса.Видимость = Истина;
		Элементы.ВидОтображенияЗапроса.Видимость = Объект.ФорматИнтеграции = Перечисления.пбп_ФорматыИнтеграций.JSON;
		Элементы.ЗапросИсходящий.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		Элементы.ЗапросВходящий.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		Элементы.ЗапросИсходящий.УстановитьДействие("ДокументСформирован", "ЗапросИсходящийДокументСформирован_Подключаемый");
		Элементы.ЗапросВходящий.УстановитьДействие("ДокументСформирован", "ЗапросВходящийДокументСформирован_Подключаемый");
	Иначе
		Элементы.ГруппаФорматированиеТекстаЗапроса.Видимость = Ложь;
		Если ЗначениеЗаполнено(Объект.ВходящееСообщение) Тогда
			ЗапросВходящийОтформатированный = ОтформатироватьСообщениеИнтеграции(Объект.ВходящееСообщение);
		КонецЕсли;
		Если ЗначениеЗаполнено(Объект.ИсходящееСообщение) Тогда
			ЗапросИсходящийОтформатированный = ОтформатироватьСообщениеИнтеграции(Объект.ИсходящееСообщение);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Строка Из Объект.ОбъектыИнтеграции Цикл
		Строка.ЗагруженныйОбъектТипЗначения = ТипЗнч(Строка.ОбъектИнтеграции);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Предопределенный = "Перечисление.пбп_ФорматыИнтеграций.ПроизвольныйФормат";
	Если ЗначениеЗаполнено(Объект.ФорматИнтеграции) 
		И Объект.ФорматИнтеграции <> пбп_ОбщегоНазначенияСлужебныйКлиент.ПредопределенныйЭлемент(Предопределенный) Тогда
		ИнициализироватьБазовыйФайлРедактора(ПолучитьФорматИнтеграции(Объект.ФорматИнтеграции));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОтображенияЗапросаПриИзменении(Элемент)
	
	Если ВидОтображенияЗапроса Тогда
		ИнициализироватьИЗаполнитьТекстомОбъектJSON("tree");
	Иначе
		ИнициализироватьИЗаполнитьТекстомОбъектJSON("code");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросИсходящийДокументСформирован_Подключаемый(Элемент)
	
	Предопределенный = "Перечисление.пбп_ФорматыИнтеграций.JSON";
	Если Объект.ФорматИнтеграции = пбп_ОбщегоНазначенияСлужебныйКлиент.ПредопределенныйЭлемент(Предопределенный) Тогда
		ИнициализироватьИЗаполнитьТекстомОбъектJSON("code", "Исходящий");
	Иначе
		ИнициализироватьИЗаполнитьТекстомОбъектXML("Исходящий");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросВходящийДокументСформирован_Подключаемый(Элемент)
	
	Предопределенный = "Перечисление.пбп_ФорматыИнтеграций.JSON";
	Если Объект.ФорматИнтеграции = пбп_ОбщегоНазначенияСлужебныйКлиент.ПредопределенныйЭлемент(Предопределенный) Тогда
		ИнициализироватьИЗаполнитьТекстомОбъектJSON("code", "Входящий");
	Иначе
		ИнициализироватьИЗаполнитьТекстомОбъектXML("Входящий");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазвернутьВсе(Команда)
	
	Предопределенный = "Перечисление.пбп_ФорматыИнтеграций.XML";
	Если Объект.ФорматИнтеграции = пбп_ОбщегоНазначенияСлужебныйКлиент.ПредопределенныйЭлемент(Предопределенный) Тогда
		Элементы.ЗапросИсходящий.Документ.defaultView.Xonomy.plusminus("xonomy1", true);
		Элементы.ЗапросВходящий.Документ.defaultView.Xonomy.plusminus("xonomy1", true);
	Иначе
		Если ВидОтображенияЗапроса Тогда
			ДокументВнешнийОбъектИсходящий.expandAll();
			ДокументВнешнийОбъектВходящий.expandAll();
		Иначе
			ДокументВнешнийОбъектИсходящий.format();
			ДокументВнешнийОбъектВходящий.format();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсе(Команда)
	
	Предопределенный = "Перечисление.пбп_ФорматыИнтеграций.XML";
	Если Объект.ФорматИнтеграции = пбп_ОбщегоНазначенияСлужебныйКлиент.ПредопределенныйЭлемент(Предопределенный) Тогда
		Элементы.ЗапросИсходящий.Документ.defaultView.Xonomy.plusminus("xonomy1", false);
		Элементы.ЗапросВходящий.Документ.defaultView.Xonomy.plusminus("xonomy1", false);
	Иначе
		Если ВидОтображенияЗапроса Тогда
			ДокументВнешнийОбъектИсходящий.collapseAll();
			ДокументВнешнийОбъектВходящий.collapseAll();
		Иначе
			ДокументВнешнийОбъектИсходящий.compact();
			ДокументВнешнийОбъектВходящий.compact();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьВБуферОбмена(Команда)
	
	#Если НЕ ВебКлиент Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация();
		Если НЕ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86 Или ТипПлатформы.Linux_x86_64 Тогда
			ОбъектКопирования = Новый COMОбъект("htmlfile");
			Если Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаЗапросВходящий" Тогда
				ПолеКопирования = Объект.ВходящееСообщение;
			ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаЗапросИсходящий" Тогда
				ПолеКопирования = Объект.ИсходящееСообщение;
			Иначе
				Возврат;
			КонецЕсли;
			ОбъектКопирования.ParentWindow.ClipboardData.SetData("Text", ПолеКопирования);
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСвойстваЭлементов()
	
	Если ЗначениеЗаполнено(Объект.ИнтеграционныйПоток) Тогда
		ТипИнтеграции = пбп_ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(
			Объект.ИнтеграционныйПоток, "НастройкаИнтеграции.ТипИнтеграции");
		ЭлементНаследования = Справочники.пбп_ТипыИнтеграций
			.ПолучитьПредопределенныйЭлементНаследованияНастроекТипаИнтеграции(ТипИнтеграции);
		Если ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.Каталог
			Или ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.FTPРесурсы Тогда
			Элементы.ИсходящееСообщение.Заголовок = НСтр("ru = 'Содержимое записываемого файла'");
			Элементы.ВходящееСообщение.Заголовок = НСтр("ru = 'Содержимое читаемого файла'");
			
			ЭтоВыгрузка = НаправлениеИнтеграцииВыгружено(Объект.Статус);
			Элементы.ИсходящееСообщение.Видимость = ЭтоВыгрузка;
			Элементы.ВходящееСообщение.Видимость = Не ЭтоВыгрузка;
		ИначеЕсли ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.ПочтовыйКлиент Тогда
			Элементы.ИсходящееСообщение.Заголовок = НСтр("ru = 'Содержимое тела письма'");
			Элементы.ИсходящееСообщение.Видимость = Истина;
			Элементы.ВходящееСообщение.Видимость = Ложь;
		ИначеЕсли ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.COM
			Или ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.ВнешняяКомпонента Тогда
			Элементы.ИсходящееСообщение.Видимость = Ложь;
			Элементы.ВходящееСообщение.Видимость = Ложь;
		ИначеЕсли ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.КоманднаяСтрока Тогда
			Элементы.ИсходящееСообщение.Заголовок = НСтр("ru = 'Выполняемая команда'");
			Элементы.ВходящееСообщение.Заголовок = НСтр("ru = 'Результат выполнения команды'");
			Элементы.ИсходящееСообщение.Видимость = Истина;
			Элементы.ВходящееСообщение.Видимость = Истина;
		Иначе
			Элементы.ИсходящееСообщение.Заголовок = НСтр("ru = 'Запрос исходящий'");
			Элементы.ВходящееСообщение.Заголовок = НСтр("ru = 'Запрос входящий'");
			Элементы.ИсходящееСообщение.Видимость = Истина;
			Элементы.ВходящееСообщение.Видимость = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаправлениеИнтеграцииВыгружено(СтатусОбмена)
	
	Возврат СтатусОбмена = Перечисления.пбп_СтатусыИнтеграции.Выгружено
		Или СтатусОбмена = Перечисления.пбп_СтатусыИнтеграции.ОшибкаВыгрузки;
	
КонецФункции

&НаСервере
Функция ОтформатироватьСообщениеИнтеграции(Знач ТекстСообщенияИнтеграции)
	
	Если Объект.ФорматИнтеграции = Перечисления.пбп_ФорматыИнтеграций.XML
		И СтрНайти(ТекстСообщенияИнтеграции, "xml") <> 0 Тогда
		Запрос = пбп_ИнтеграцииСервер.ОтформатироватьXMLЧерезDOM(ТекстСообщенияИнтеграции, Истина);
	Иначе
		Запрос = ТекстСообщенияИнтеграции;
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

&НаКлиенте
Процедура ИнициализироватьБазовыйФайлРедактора(ФорматИнтеграции)
	
	#Если ВебКлиент Тогда
		ВызватьИсключение НСтр("ru = 'Редактор " + ФорматИнтеграции + " не предназначен для веб-клиента'");
	#Иначе
		Если ФорматИнтеграции = "JSON" Тогда
			ЗапросИсходящийОтформатированный	= ПолучитьБазовыйФайлРедактора(ФорматИнтеграции);
			ЗапросВходящийОтформатированный		= ЗапросИсходящийОтформатированный;
		Иначе
			ЗапросИсходящийОтформатированный	= ПолучитьБазовыйФайлРедактора(ФорматИнтеграции, "Out");
			ЗапросВходящийОтформатированный		= ПолучитьБазовыйФайлРедактора(ФорматИнтеграции, "In");
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьБазовыйФайлРедактора(ФорматИнтеграции, Дополнение = "")
	
	#Если НЕ ВебКлиент Тогда
		КаталогКомпоненты = КаталогВременныхФайлов() + ФорматИнтеграции + "Editor" + Дополнение;
		КаталогНаДиске = Новый Файл(КаталогКомпоненты);
		ДвоичныеДанные = ДвоичныеДанныеМакета(ФорматИнтеграции);
		
		Чтение = Новый ЧтениеДанных(ДвоичныеДанные);
		Файл = Новый ЧтениеZipФайла(Чтение.ИсходныйПоток());
		Файл.ИзвлечьВсе(КаталогКомпоненты);
		
		БазовыйФайлРедактора = КаталогКомпоненты + ПолучитьРазделительПути() + "index.html";
			
		Возврат БазовыйФайлРедактора;
	#КонецЕсли
	
КонецФункции

&НаКлиенте
Процедура ИнициализироватьИЗаполнитьТекстомОбъектJSON(ВидОтображения, ТипЗапроса = "")
	
	Если ТипЗапроса = "Исходящий" Тогда
		Если ДокументВнешнийОбъектИсходящий <> Неопределено Тогда
			ДокументВнешнийОбъектИсходящий.destroy();
		КонецЕсли;
		
		ДокументВнешнийОбъектИсходящий = Элементы.ЗапросИсходящий.Документ.defaultView.Init(ВидОтображения);
		ДокументВнешнийОбъектИсходящий.setName("Корень"); // Установка имени верхнего уровня для дерева
		ДокументВнешнийОбъектИсходящий.setText(Объект.ИсходящееСообщение);
	
	ИначеЕсли ТипЗапроса = "Входящий" Тогда
		Если ДокументВнешнийОбъектВходящий <> Неопределено Тогда
			ДокументВнешнийОбъектВходящий.destroy();
		КонецЕсли;
		
		ДокументВнешнийОбъектВходящий = Элементы.ЗапросВходящий.Документ.defaultView.Init(ВидОтображения);
		ДокументВнешнийОбъектВходящий.setName("Корень"); // Установка имени верхнего уровня для дерева
		ДокументВнешнийОбъектВходящий.setText(Объект.ВходящееСообщение);
	Иначе
		Если ДокументВнешнийОбъектИсходящий <> Неопределено Тогда
			ДокументВнешнийОбъектИсходящий.destroy();
		КонецЕсли;
		
		ДокументВнешнийОбъектИсходящий = Элементы.ЗапросИсходящий.Документ.defaultView.Init(ВидОтображения);
		ДокументВнешнийОбъектИсходящий.setName("Корень"); // Установка имени верхнего уровня для дерева
		ДокументВнешнийОбъектИсходящий.setText(Объект.ИсходящееСообщение);
		
		Если ДокументВнешнийОбъектВходящий <> Неопределено Тогда
			ДокументВнешнийОбъектВходящий.destroy();
		КонецЕсли;
		
		ДокументВнешнийОбъектВходящий = Элементы.ЗапросВходящий.Документ.defaultView.Init(ВидОтображения);
		ДокументВнешнийОбъектВходящий.setName("Корень"); // Установка имени верхнего уровня для дерева
		ДокументВнешнийОбъектВходящий.setText(Объект.ВходящееСообщение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьИЗаполнитьТекстомОбъектXML(ТипЗапроса)
	
	Если ТипЗапроса = "Исходящий" Тогда
		Элементы.ЗапросИсходящий.Документ.defaultView.start(
			ОтформатироватьСообщениеИнтеграции(Объект.ИсходящееСообщение), "nerd");
	Иначе
		Элементы.ЗапросВходящий.Документ.defaultView.start(
			ОтформатироватьСообщениеИнтеграции(Объект.ВходящееСообщение), "nerd");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДвоичныеДанныеМакета(ФорматИнтеграции)
	
	Возврат ПолучитьОбщийМакет("пбп_" + ФорматИнтеграции + "Editor");
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьФорматИнтеграции(ФорматИнтеграции)
	
	ИндексЗначенияПеречисления = Перечисления.пбп_ФорматыИнтеграций.Индекс(ФорматИнтеграции);
	ФорматИнтеграции = Метаданные.Перечисления.пбп_ФорматыИнтеграций.ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;
	
	Возврат ФорматИнтеграции;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
