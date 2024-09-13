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

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	УстановитьСвойстваЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Модифицированность И Не ПустаяСтрока(Объект.ИдентификаторНастройки) Тогда
		ТекущийОбъект.ИзмененВручную = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИспользоватьРегламентноеЗаданиеПриИзмененииНаСервере()
	
	РегламентноеЗадание = ПолучитьРегламентноеЗадание();
	Если РегламентноеЗадание = Неопределено Тогда
		СоздатьРегламентноеЗадание();
	Иначе
		ОбновитьОтключитьРегламентноеЗадание();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРегламентноеЗаданиеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстСообщения = НСтр("ru = 'Для настройки расписания выполнения задания необходимо записать справочник. Записать?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ИспользоватьРегламентноеЗаданиеПриИзмененииЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстСообщения, РежимДиалогаВопрос.ОКОтмена);
	Иначе
		НастроитьДоступностьСсылкиНастройкиРасписания();
		
		ИспользоватьРегламентноеЗаданиеПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НастройкаИнтеграцииПриИзменении(Элемент)
	
	УстановитьСвойстваЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИнтеграцииНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	
	Если Не ПустаяСтрока(Объект.ИдентификаторНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	НовыйПараметр = Новый ПараметрВыбора("Отбор.Ссылка", СписокФайловыхНастроекИнтеграции(""));
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(НовыйПараметр);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элемент.ПараметрыВыбора = НовыеПараметры;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаИнтеграцииАвтоПодбор(Элемент, Текст,
	ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Не ПустаяСтрока(Объект.ИдентификаторНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.ЗагрузитьЗначения(СписокФайловыхНастроекИнтеграции(Текст));
	ДанныеВыбора = СписокЗначений;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗадания(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("РедактированиеРасписаниеРегламентногоЗаданияЗавершение", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ПользовательскаяФункцияПриИзменении(Элемент)
	Если ПроверитьВидимостьНастроекРасписания() Тогда
		Элементы.ГруппаРегламентноеЗадание.Видимость = Истина;
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Элементы.НастроитьРасписаниеРегламентногоЗадания.Доступность = Истина;
		Иначе
			Элементы.НастроитьРасписаниеРегламентногоЗадания.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если ПроверитьВидимостьНастроекРасписания() И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		РегламентноеЗадание = ПолучитьРегламентноеЗадание();
		Если РегламентноеЗадание <> Неопределено Тогда
			РасписаниеРегламентногоЗадания	= РегламентноеЗадание.Расписание;
			ИспользоватьРегламентноеЗадание	= РегламентноеЗадание.Использование;
		КонецЕсли;
	Иначе
		Элементы.ГруппаРегламентноеЗадание.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементов()
	
	ТочкаВхода					= "ТочкаВхода";
	ПользовательскаяФункция		= "ПользовательскаяФункция";
	ПараметрыВходаСтрока		= "ПараметрыВхода";
	ПараметрыВходаПараметрURL	= "ПараметрыВходаПараметрURL";
	
	КонечнаяТочкаСтрока			= НСтр("ru = 'Конечная точка'");
	ПараметрыЗапросаСтрока		= НСтр("ru = 'Параметры запроса'");
	
	УстанавливаемоеСвойство = "Видимость";
	
	Если Не ЗначениеЗаполнено(Объект.НастройкаИнтеграции) Тогда
		пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, ТочкаВхода, УстанавливаемоеСвойство, Ложь);
		пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, ПользовательскаяФункция, УстанавливаемоеСвойство, Ложь);
		пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, ПараметрыВходаСтрока, УстанавливаемоеСвойство, Ложь);
	Иначе
		РеквизитыОбъекта = пбп_ОбщегоНазначенияСервер.ЗначенияРеквизитовОбъекта(
			Объект.НастройкаИнтеграции, "ТипИнтеграции, ИспользоватьПользовательскиеФункции");
		ЭлементНаследования = Справочники.пбп_ТипыИнтеграций
			.ПолучитьПредопределенныйЭлементНаследованияНастроекТипаИнтеграции(РеквизитыОбъекта.ТипИнтеграции);
		Если ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.Каталог
			Или ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.FTPРесурсы
			Или ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.ПочтовыйКлиент Тогда
			УстановитьВидимостьЭлементовДляТипаФайловыеОбмены();
			
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, "ПользовательскаяФункция", УстанавливаемоеСвойство,
				РеквизитыОбъекта.ИспользоватьПользовательскиеФункции);
		ИначеЕсли ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.COM Тогда
			Элементы.ТочкаВхода.Заголовок = НСтр("ru = 'Функция / запрос'");
			
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ТочкаВхода, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПользовательскаяФункция, УстанавливаемоеСвойство, Ложь);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаСтрока, УстанавливаемоеСвойство, Ложь);
		ИначеЕсли ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.RESTAPI Тогда
			Элементы.ТочкаВхода.Заголовок = НСтр("ru = 'Ресурс'");
			Элементы.ПараметрыВхода.Заголовок = НСтр("ru = 'Параметры запроса / URL'");
			
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ТочкаВхода, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПользовательскаяФункция, УстанавливаемоеСвойство, Ложь);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаСтрока, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаПараметрURL, УстанавливаемоеСвойство, Истина);
		ИначеЕсли ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.SOAP Тогда
			Элементы.ТочкаВхода.Заголовок = КонечнаяТочкаСтрока;
			Элементы.ПараметрыВхода.Заголовок = ПараметрыЗапросаСтрока;
			
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ТочкаВхода, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПользовательскаяФункция, УстанавливаемоеСвойство, Ложь);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаСтрока, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаПараметрURL, УстанавливаемоеСвойство, Ложь);
		ИначеЕсли ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.ПрямоеПодключениеКБД Тогда
			Элементы.ТочкаВхода.Заголовок = НСтр("ru = 'Текст запроса'");
			Элементы.ПараметрыВхода.Заголовок = ПараметрыЗапросаСтрока;
			
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ТочкаВхода, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПользовательскаяФункция, УстанавливаемоеСвойство, Ложь);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаСтрока, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаПараметрURL, УстанавливаемоеСвойство, Ложь);
		ИначеЕсли ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.ВнешняяКомпонента Тогда
			Элементы.ТочкаВхода.Заголовок = НСтр("ru = 'Функция'");
			
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ТочкаВхода, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПользовательскаяФункция, УстанавливаемоеСвойство, Ложь);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаСтрока, УстанавливаемоеСвойство, Ложь);
		ИначеЕсли ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.КоманднаяСтрока Тогда
			Элементы.ТочкаВхода.Заголовок = НСтр("ru = 'Команда'");
			Элементы.ПараметрыВхода.Заголовок = НСтр("ru = 'Аргументы команды'");
			
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ТочкаВхода, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПользовательскаяФункция, УстанавливаемоеСвойство, Ложь);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаСтрока, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаПараметрURL, УстанавливаемоеСвойство, Ложь);
			
		ИначеЕсли ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.БрокерыСообщений Тогда
			Элементы.ТочкаВхода.Заголовок = КонечнаяТочкаСтрока;
			
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ТочкаВхода, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПользовательскаяФункция, УстанавливаемоеСвойство, Ложь);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаСтрока, УстанавливаемоеСвойство, Ложь);
			
		Иначе
			Элементы.ТочкаВхода.Заголовок = КонечнаяТочкаСтрока;
			Элементы.ПараметрыВхода.Заголовок = НСтр("ru = 'Параметры'");
			
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ТочкаВхода, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПользовательскаяФункция, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаСтрока, УстанавливаемоеСвойство, Истина);
			пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы, ПараметрыВходаПараметрURL, УстанавливаемоеСвойство, Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовДляТипаФайловыеОбмены()
	
	УстанавливаемоеСвойство = "Видимость";
	
	пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ТочкаВхода", УстанавливаемоеСвойство, Ложь);
	пбп_ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "ПараметрыВхода", УстанавливаемоеСвойство, Ложь);
	
КонецПроцедуры

&НаСервере
Функция ПроверитьВидимостьНастроекРасписания()
	
	ПользовательскиеФункцииДоступны = пбп_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеКонстанты(
		"пбп_ИспользоватьПользовательскиеФункции");
	ДоступноПоРолям = ПравоДоступа("Изменение",
		Метаданные.Справочники.пбп_ИнтеграционныеПотоки,
		пбп_Пользователи.ТекущийПользователь());
	
	Если Не (ПользовательскиеФункцииДоступны И ДоступноПоРолям) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТипИнтеграции = пбп_ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта(
		Объект.НастройкаИнтеграции, "ТипИнтеграции");
	ЭлементНаследования = Справочники.пбп_ТипыИнтеграций
		.ПолучитьПредопределенныйЭлементНаследованияНастроекТипаИнтеграции(ТипИнтеграции);
	Если ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.Каталог
		Или ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.FTPРесурсы
		Или ЭлементНаследования = Справочники.пбп_ТипыИнтеграций.ПочтовыйКлиент Тогда
		ДоступноПоНастройке = Истина;
	Иначе
		ДоступноПоНастройке = Ложь;
	КонецЕсли;
	
	Возврат ДоступноПоНастройке;
	
КонецФункции

&НаКлиенте
Процедура ИспользоватьРегламентноеЗаданиеПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Записать();
		НастроитьДоступностьСсылкиНастройкиРасписания();
		СоздатьРегламентноеЗадание();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеРасписаниеРегламентногоЗаданияЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		РасписаниеРегламентногоЗадания = Расписание;
		ОбновитьОтключитьРегламентноеЗадание();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьДоступностьСсылкиНастройкиРасписания()
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Доступность = ИспользоватьРегламентноеЗадание;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОтключитьРегламентноеЗадание()
	
	РегламентноеЗадание = ПолучитьРегламентноеЗадание();
	
	РегламентноеЗадание.Расписание		= РасписаниеРегламентногоЗадания;
	РегламентноеЗадание.Использование	= ИспользоватьРегламентноеЗадание;
	РегламентноеЗадание.Записать();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРегламентноеЗадание()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	КлючЗадания = ПолучитьУникальныйИдентификаторТекущейНастройки();
	
	ОтборЗадания = Новый Структура;
	ОтборЗадания.Вставить("Ключ", КлючЗадания);
	МассивРегламентныхЗаданий = пбп_РегламентныеЗаданияСервер.НайтиЗадания(ОтборЗадания);
	
	Если МассивРегламентныхЗаданий.Количество() Тогда
		РегламентноеЗадание = МассивРегламентныхЗаданий[0];
	Иначе
		РегламентноеЗадание = Неопределено;
	КонецЕсли;
	
	Возврат РегламентноеЗадание;
	
КонецФункции

&НаСервере
Процедура СоздатьРегламентноеЗадание()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗадания = Новый Структура;
	НаименованиеРеглЗадания = пбп_СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		"ru = 'Выполнение пользовательской функции: выполнение пользовательской функции по настройке интеграции ""%1""'",
		Объект.НастройкаИнтеграции.Наименование);
	ПараметрыЗадания.Вставить("Наименование"	, НСтр(НаименованиеРеглЗадания));
	ПараметрыЗадания.Вставить("Использование"	, Истина);
	ПараметрыЗадания.Вставить("Метаданные"		, Метаданные.РегламентныеЗадания
		.пбп_ВыполнениеПользовательскихФункцийФайловыхОбменов);

	ПараметрыРегламентногоЗадания = Новый Массив;
	ПараметрыРегламентногоЗадания.Добавить(Объект.НастройкаИнтеграции);
	ПараметрыРегламентногоЗадания.Добавить(Объект.ПользовательскаяФункция);
	ПараметрыЗадания.Вставить("Параметры", ПараметрыРегламентногоЗадания);

	КлючЗадания = ПолучитьУникальныйИдентификаторТекущейНастройки();
	ПараметрыЗадания.Вставить("Ключ", КлючЗадания);
	ПараметрыЗадания.Вставить("Расписание", Новый РасписаниеРегламентногоЗадания);

	РегламентноеЗадание = пбп_РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
	
	РасписаниеРегламентногоЗадания	= РегламентноеЗадание.Расписание;
	ИспользоватьРегламентноеЗадание	= РегламентноеЗадание.Использование;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьУникальныйИдентификаторТекущейНастройки()
	
	Возврат Строка(Объект.Ссылка.УникальныйИдентификатор());
	
КонецФункции

&НаСервере
Функция СписокФайловыхНастроекИнтеграции(Знач Текст)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	пбп_НастройкиИнтеграции.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.пбп_НастройкиИнтеграции КАК пбп_НастройкиИнтеграции
	|ГДЕ
	|	пбп_НастройкиИнтеграции.ТипИнтеграции В ИЕРАРХИИ (&Ссылка)";
	
	Если Не ПустаяСтрока(Текст) Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И пбп_НастройкиИнтеграции.Наименование ПОДОБНО &Текст";
		
		Запрос.УстановитьПараметр("Текст", Текст + "%");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка", Справочники.пбп_ТипыИнтеграций.ФайловыеОбмены);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
