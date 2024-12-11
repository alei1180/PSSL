﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8,
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
// URL: https://github.com/firstBitSportivnaya/PSSL/
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция ОпределитьМодульПереадресации предназначена для проверки наличия общего модуля
// БСП с указанным именем и получения этого модуля, если он существует.
//
// Параметры:
//  ИмяМодуля	 - Строка - имя общего модуля, который необходимо найти.
// 
// Возвращаемое значение:
//  Структура - общий модуль и что он существует
//  * Модуль 	- ОбщийМодуль - общий модуль из БСП.
//  * МодульСуществует - Булево - Если флаг истина, модуль существует.
//
Функция ОпределитьМодульПереадресации(ИмяМодуля) Экспорт
	
	Результат = Новый Структура("Модуль, МодульСуществует", , Ложь);
	
	Если Не пбп_ОбщегоНазначенияВызовСервера.СуществуетБиблиотекаСтандартныхПодсистем() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.Модуль = пбп_ОбщегоНазначенияКлиент.ОбщийМодуль(ИмяМодуля);
	Результат.МодульСуществует = Истина;
	
	Возврат Результат;
	
КонецФункции

#Область ПереадресацияМетодов

#Область ОбщегоНазначенияКлиент

// Аналог метода БСП. Формирует и выводит сообщение, которое может быть связано с элементом управления формы.
//
// См. ОбщегоНазначения.СообщитьПользователю
//
// Параметры:
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных - ЛюбаяСсылка - объект или ключ записи информационной базы, к которому это сообщение относится.
//  Поле - Строка - наименование реквизита формы.
//  ПутьКДанным - Строка - путь к данным (путь к реквизиту формы).
//  Отказ - Булево - выходной параметр, всегда устанавливается в значение Истина.
//
// Пример:
//
//  1. Для вывода сообщения у поля управляемой формы, связанного с реквизитом объекта:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ПолеВРеквизитеФормыОбъект",
//   "Объект");
//
//  Альтернативный вариант использования в форме объекта:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "Объект.ПолеВРеквизитеФормыОбъект");
//
//  2. Для вывода сообщения рядом с полем управляемой формы, связанным с реквизитом формы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ИмяРеквизитаФормы");
//
//  3. Для вывода сообщения связанного с объектом информационной базы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ОбъектИнформационнойБазы, "Ответственный",,Отказ);
//
//  4. Для вывода сообщения по ссылке на объект информационной базы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), Ссылка, , , Отказ);
//
//  Случаи некорректного использования:
//   1. Передача одновременно параметров КлючДанных и ПутьКДанным.
//   2. Передача в параметре КлючДанных значения типа отличного от допустимого.
//   3. Установка ссылки без установки поля (и/или пути к данным).
//
Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю,	Знач КлючДанных = Неопределено,
	Знач Поле = "", Знач ПутьКДанным = "", Отказ = Ложь) Экспорт
	
	Результат = ПереадресацияМодуляОбщегоНазначенияКлиент();
	Если Результат.МодульСуществует Тогда
		Результат.Модуль.СообщитьПользователю(ТекстСообщенияПользователю, КлючДанных, Поле, ПутьКДанным, Отказ);
		Возврат;
	КонецЕсли;
	
	Сообщение = пбп_ПереадресацияКлиентСервер.СообщениеПользователю(ТекстСообщенияПользователю,
		КлючДанных, Поле, ПутьКДанным, Отказ);
	
	Сообщение.Сообщить();
	
КонецПроцедуры

// Аналог метода БСП. Возвращает ссылку предопределенного элемента по его полному имени.
// Предопределенные элементы могут содержаться только в следующих объектах:
//   - справочники;
//   - планы видов характеристик;
//   - планы счетов;
//   - планы видов расчета.
// После изменения состава предопределенных следует выполнить метод
// ОбновитьПовторноИспользуемыеЗначения(), который сбросит кэш ПовтИсп в текущем сеансе.
//
// См. ОбщегоНазначения.ПредопределенныйЭлемент
//
// Параметры:
//   ПолноеИмяПредопределенного - Строка - полный путь к предопределенному элементу, включая его имя.
//     Формат аналогичен функции глобального контекста ПредопределенноеЗначение().
//     Например:
//       "Справочник.ВидыКонтактнойИнформации.EmailПользователя"
//       "ПланСчетов.Хозрасчетный.Материалы"
//       "ПланВидовРасчета.Начисления.ОплатаПоОкладу".
//
// Возвращаемое значение: 	
//   ЛюбаяСсылка - ссылка на предопределенный элемент.
//   Неопределено - если предопределенный элемент есть в метаданных, но не создан в ИБ.
//
Функция ПредопределенныйЭлемент(ПолноеИмяПредопределенного) Экспорт
	
	Результат = ПереадресацияМодуляОбщегоНазначенияКлиент();
	Если Результат.МодульСуществует Тогда
		Возврат Результат.Модуль.ПредопределенныйЭлемент(ПолноеИмяПредопределенного);
	КонецЕсли;
	
	Возврат ПредопределенноеЗначение(ПолноеИмяПредопределенного);
	
КонецФункции

// Аналог метода БСП. Возвращает Истина, если клиентское приложение запущено под управлением ОС Windows.
//
// См. ОбщегоНазначения.ЭтоWindowsКлиент
//
// Возвращаемое значение:
//  Булево - если нет клиентского приложения, возвращается Ложь.
//
Функция ЭтоWindowsКлиент() Экспорт
	
	Результат = ПереадресацияМодуляОбщегоНазначенияКлиент();
	Если Результат.МодульСуществует Тогда
		Возврат Результат.Модуль.ЭтоWindowsКлиент();
	КонецЕсли;
	
	ТипПлатформыКлиента = ТипПлатформыКлиента();
	Возврат ТипПлатформыКлиента = ТипПлатформы.Windows_x86
		Или ТипПлатформыКлиента = ТипПлатформы.Windows_x86_64;
	
КонецФункции
	
// Аналог метода БСП. Возвращает тип платформы клиента.
//
// Возвращаемое значение:
//  ТипПлатформы, Неопределено - тип платформы на которой запущен клиент. В режиме веб-клиента, если тип 
//                               платформы иной, чем описан в типе ТипПлатформы, то возвращается Неопределено.
//
Функция ТипПлатформыКлиента() Экспорт
	
	Результат = ПереадресацияМодуляОбщегоНазначенияКлиент();
	Если Результат.МодульСуществует Тогда
		Возврат Результат.Модуль.ТипПлатформыКлиента();
	КонецЕсли;
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	Возврат СистемнаяИнфо.ТипПлатформы;
	
КонецФункции

#КонецОбласти

#Область ФайловаяСистемаКлиент

// Аналог метода БСП. Получение имени временного каталога.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение о результате получения со следующими параметрами.
//    -- ИмяКаталога             - Строка - путь к созданному каталогу.
//    -- ДополнительныеПараметры - Структура - значение, которое было указано при создании объекта ОписаниеОповещения.
//  Расширение - Строка - суффикс в имени каталога, который поможет идентифицировать каталог при анализе.
//
Процедура СоздатьВременныйКаталог(Знач Оповещение, Расширение = "") Экспорт
	
	Результат = ПереадресацияМодуляФайловаяСистемаКлиент();
	Если Результат.МодульСуществует Тогда
		Результат.Модуль.СоздатьВременныйКаталог(Оповещение, Расширение);
		Возврат;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("Расширение", Расширение);
	
	Оповещение = Новый ОписаниеОповещения("СоздатьВременныйКаталогПослеПроверкиРасширенияРаботыСФайлами",
		пбп_ПереадресацияКлиент, Контекст);
	ПодключитьРасширениеДляРаботыСФайлами(Оповещение, 
		НСтр("ru = 'Для создания временной папки установите расширение для работы с 1С:Предприятием.'"), Ложь);
	
КонецПроцедуры

// Аналог метода БСП. Предлагает пользователю установить расширение для работы с 1С:Предприятием в веб-клиенте.
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами.
//
// Параметры:
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - описание процедуры, которая будет вызвана после закрытия
//          формы со следующими параметрами:
//    -- РасширениеПодключено - Булево - Истина, если расширение было подключено.
//    -- ДополнительныеПараметры - Произвольный - параметры, заданные в ОписаниеОповещенияОЗакрытии.
//  ТекстПредложения - Строка - текст сообщения. Если не указан, то выводится текст по умолчанию.
//  ВозможноПродолжениеБезУстановки - Булево - если Истина, будет показана кнопка ПродолжитьБезУстановки,
//          если Ложь, будет показана кнопка Отмена.
//
// Пример:
//
//  Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//  ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение для работы с 1С:Предприятием.'");
//  ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстСообщения);
//
//  Процедура ПечатьДокументаЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
//    Если РасширениеПодключено Тогда
//     // код печати документа, рассчитывающий на то, что расширение подключено.
//     // ...
//    Иначе
//     // код печати документа, который работает без подключенного расширения.
//     // ...
//    КонецЕсли;
//
Процедура ПодключитьРасширениеДляРаботыСФайлами(
		ОписаниеОповещенияОЗакрытии, 
		ТекстПредложения = "",
		ВозможноПродолжениеБезУстановки = Истина) Экспорт
		
	Результат = ПереадресацияМодуляФайловаяСистемаКлиент();
	Если Результат.МодульСуществует Тогда
		Результат.Модуль.ПодключитьРасширениеДляРаботыСФайлами(
			ОписаниеОповещенияОЗакрытии,
			ТекстПредложения,
			ВозможноПродолжениеБезУстановки);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения(
		"НачатьПодключениеРасширенияРаботыСФайламиПриОтветеНаВопросОбУстановке", пбп_ПереадресацияКлиент,
		ОписаниеОповещенияОЗакрытии);
	
#Если Не ВебКлиент Тогда
	// В мобильном, тонком и толстом клиентах расширение подключено всегда.
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
	Возврат;
#КонецЕсли
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);
	Контекст.Вставить("ТекстПредложения",             ТекстПредложения);
	Контекст.Вставить("ВозможноПродолжениеБезУстановки", ВозможноПродолжениеБезУстановки);
	
	Оповещение = Новый ОписаниеОповещения(
		"НачатьПодключениеРасширенияРаботыСФайламиПриУстановкеРасширения", пбп_ПереадресацияКлиент, Контекст);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ПереадресацияМетодов

#Область СтандартныеПодсистемыКлиент

// Аналог метода БСП. Разворачивает узлы указанного дерева на форме.
//
// Параметры:
//   Форма                     - ФормаКлиентскогоПриложения - форма, на которой размещен элемент управления с деревом значений.
//   ИмяЭлементаФормы          - Строка           - имя элемента с таблицей формы (деревом значений) и связанного с ней
//                                                  реквизита формы (должны совпадать).
//   ИдентификаторСтрокиДерева - Произвольный     - идентификатор строки дерева, которую требуется развернуть.
//                                                  Если указано "*", то будут развернуты все узлы верхнего уровня.
//                                                  Если указано Неопределено, то строки дерева развернуты не будут.
//                                                  Значение по умолчанию: "*".
//   РазвернутьСПодчиненными   - Булево           - если Истина, то следует раскрыть также и все подчиненные узлы.
//                                                  По умолчанию Ложь.
//
Процедура РазвернутьУзлыДерева(Форма, ИмяЭлементаФормы, ИдентификаторСтрокиДерева = "*", РазвернутьСПодчиненными = Ложь) Экспорт
	
	Результат = ПереадресацияМодуляСтандартныеПодсистемыКлиент();
	Если Результат.МодульСуществует Тогда
		Результат.Модуль.РазвернутьУзлыДерева(Форма, ИмяЭлементаФормы, ИдентификаторСтрокиДерева, РазвернутьСПодчиненными);
		Возврат;
	КонецЕсли;
	
	ТаблицаЭлемент = Форма.Элементы[ИмяЭлементаФормы];
	Если ИдентификаторСтрокиДерева = "*" Тогда
		Узлы = Форма[ИмяЭлементаФормы].ПолучитьЭлементы();
		Для Каждого Узел Из Узлы Цикл
			ТаблицаЭлемент.Развернуть(Узел.ПолучитьИдентификатор(), РазвернутьСПодчиненными);
		КонецЦикла;
	Иначе
		ТаблицаЭлемент.Развернуть(ИдентификаторСтрокиДерева, РазвернутьСПодчиненными);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область МодульПереадресацииПоПодсистемам

Функция ПереадресацияМодуляОбщегоНазначенияКлиент()
	Возврат пбп_ПереадресацияКлиентПовтИсп.ОпределитьМодульПереадресации("ОбщегоНазначенияКлиент");
КонецФункции

Функция ПереадресацияМодуляСтандартныеПодсистемыКлиент()
	Возврат пбп_ПереадресацияКлиентПовтИсп.ОпределитьМодульПереадресации("СтандартныеПодсистемыКлиент");
КонецФункции

Функция ПереадресацияМодуляФайловаяСистемаКлиент()
	Возврат пбп_ПереадресацияКлиентПовтИсп.ОпределитьМодульПереадресации("ФайловаяСистемаКлиент");
КонецФункции

Функция ПереадресацияМодуляФайловаяСистемаСлужебныйКлиент()
	Возврат пбп_ПереадресацияКлиентПовтИсп.ОпределитьМодульПереадресации("ФайловаяСистемаСлужебныйКлиент");
КонецФункции

#КонецОбласти

#Область ПереадресацияМетодов

#Область ФайловаяСистемаСлужебныйКлиент

#Область РасширениеРаботыСФайлами

// Аналог метода БСП.
//
Процедура НачатьПодключениеРасширенияРаботыСФайламиПриУстановкеРасширения(Подключено, Контекст) Экспорт
	
	Результат = ПереадресацияМодуляФайловаяСистемаСлужебныйКлиент();
	Если Результат.МодульСуществует Тогда
		Результат.Модуль.НачатьПодключениеРасширенияРаботыСФайламиПриУстановкеРасширения(Подключено, Контекст);
		Возврат;
	КонецЕсли;
	
	// Если расширение и так уже подключено, незачем про него спрашивать.
	Если Подключено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
		Возврат;
	КонецЕсли;
	
	ВызватьИсключение НСтр("ru = 'Невозможно работать с файловой системой из браузера';");
	
КонецПроцедуры

// Аналог метода БСП.
//
Процедура НачатьПодключениеРасширенияРаботыСФайламиПриОтветеНаВопросОбУстановке(Действие, ОповещениеОЗакрытии) Экспорт
	
	Результат = ПереадресацияМодуляФайловаяСистемаСлужебныйКлиент();
	Если Результат.МодульСуществует Тогда
		Результат.Модуль
			.НачатьПодключениеРасширенияРаботыСФайламиПриОтветеНаВопросОбУстановке(Действие, ОповещениеОЗакрытии);
		Возврат;
	КонецЕсли;
	
	РасширениеПодключено = (Действие = "РасширениеПодключено" Или Действие = "ПодключениеНеТребуется");
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, РасширениеПодключено);
	
КонецПроцедуры

#КонецОбласти // РасширениеРаботыСФайлам

#Область ВременныеФайлы

#Область СоздатьВременныйКаталог

// Аналог метода БСП. Продолжение процедуры ФайловаяСистемаКлиент.СоздатьВременныйКаталог.
// 
// Параметры:
//  РасширениеПодключено - Булево
//  Контекст - Структура:
//   * Оповещение - ОписаниеОповещения
//   * Расширение - Строка
//
Процедура СоздатьВременныйКаталогПослеПроверкиРасширенияРаботыСФайлами(РасширениеПодключено, Контекст) Экспорт
	
	Результат = ПереадресацияМодуляФайловаяСистемаСлужебныйКлиент();
	Если Результат.МодульСуществует Тогда
		Результат.Модуль.СоздатьВременныйКаталогПослеПроверкиРасширенияРаботыСФайлами(РасширениеПодключено, Контекст);
		Возврат;
	КонецЕсли;
	
	Если РасширениеПодключено Тогда
		Оповещение = Новый ОписаниеОповещения(
			"СоздатьВременныйКаталогПослеПолученияВременногоКаталога", ЭтотОбъект, Контекст,
			"СоздатьВременныйКаталогПриОбработкеОшибки", ЭтотОбъект);
		НачатьПолучениеКаталогаВременныхФайлов(Оповещение);
	Иначе
		СоздатьВременныйКаталогОповеститьОбОшибке(НСтр("ru = 'Не удалось установить расширение для работы с 1С:Предприятием.'"), Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Аналог метода БСП. Продолжение процедуры ФайловаяСистемаКлиент.СоздатьВременныйКаталог.
// 
// Параметры:
//  ИмяКаталогаВременныхФайлов - Строка
//  Контекст - Структура:
//   * Оповещение - ОписаниеОповещения
//   * Расширение - Строка
//
Процедура СоздатьВременныйКаталогПослеПолученияВременногоКаталога(ИмяКаталогаВременныхФайлов, Контекст) Экспорт 
	
	Результат = ПереадресацияМодуляФайловаяСистемаСлужебныйКлиент();
	Если Результат.МодульСуществует Тогда
		Результат.Модуль.СоздатьВременныйКаталогПослеПолученияВременногоКаталога(ИмяКаталогаВременныхФайлов, Контекст);
		Возврат;
	КонецЕсли;
	
	Оповещение = Контекст.Оповещение;
	Расширение = Контекст.Расширение;
	
	ИмяКаталога = "v8_" + Строка(Новый УникальныйИдентификатор);
	
	Если Не ПустаяСтрока(Расширение) Тогда 
		ИмяКаталога = ИмяКаталога + "." + Расширение;
	КонецЕсли;
	
	НачатьСозданиеКаталога(Оповещение, ИмяКаталогаВременныхФайлов + ИмяКаталога);
	
КонецПроцедуры

// Аналог метода БСП. Продолжение процедуры ФайловаяСистемаКлиент.СоздатьВременныйКаталог.
Процедура СоздатьВременныйКаталогПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт 
	
	Результат = ПереадресацияМодуляФайловаяСистемаСлужебныйКлиент();
	Если Результат.МодульСуществует Тогда
		Результат.Модуль.СоздатьВременныйКаталогПриОбработкеОшибки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст);
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	СоздатьВременныйКаталогОповеститьОбОшибке(ОписаниеОшибки, Контекст);
	
КонецПроцедуры

// Аналог метода БСП. Продолжение процедуры ФайловаяСистемаКлиент.СоздатьВременныйКаталог.
Процедура СоздатьВременныйКаталогОповеститьОбОшибке(ОписаниеОшибки, Контекст)
	
	Результат = ПереадресацияМодуляФайловаяСистемаСлужебныйКлиент();
	Если Результат.МодульСуществует Тогда
		Результат.Модуль.СоздатьВременныйКаталогОповеститьОбОшибке(ОписаниеОшибки, Контекст);
		Возврат;
	КонецЕсли;
	
	ПоказатьПредупреждение(, ОписаниеОшибки);
	ИмяКаталога = "";
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, ИмяКаталога);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецОбласти