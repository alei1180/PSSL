﻿// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8, включая доработку типовых конфигураций.
//
// Copyright 2017-2024 First BIT company
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
//
// URL:    https://github.com/firstBitSportivnaya/PSSL/
// e-mail: ivssmirnov@1bit.com
// Версия: 1.0.0.1
//
// Требования: платформа 1С версии 8.3.17 и выше

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Обновляет тексты предопределенных элементов справочника пользовательские функции.
//
Процедура ОбновитьПредопределенныеЭлементы(Знач Макет = Неопределено, РежимСообщений = "Все") Экспорт
	
	ВыводитьОшибки = ?(РежимСообщений = "Все" Или РежимСообщений = "Ошибки", Истина, Ложь);
	ВыводитьИнформацию = ?(РежимСообщений = "Все", Истина, Ложь);
	
	Если Макет = Неопределено Тогда
		Макет = Справочники.__ПользовательскиеФункции.ПолучитьМакет("НастройкиПоУмолчанию");
	КонецЕсли;
	
	ТекстМакета = Макет.ПолучитьТекст();
	СтруктураТаблиц = Новый Структура;
	
	КоличествоТаблиц = 0;
	Пока Истина Цикл
		НомерПервойПозиции = Найти(ТекстМакета, "<Items");
		НомерПоследнейПозиции = Найти(ТекстМакета, "</Items>");
		
		Если НомерПервойПозиции = 0
			Или НомерПоследнейПозиции = 0
			Или КоличествоТаблиц > 99 Тогда
			
			Прервать;
		КонецЕсли;
		
		ТекстОписанияТаблицы = Сред(ТекстМакета, НомерПервойПозиции, НомерПоследнейПозиции+7);
		ТекстМакета = СтрЗаменить(ТекстМакета, ТекстОписанияТаблицы, "");
		
		Структура = __ОбщегоНазначенияСервер.ПрочитатьXMLВТаблицу(ТекстОписанияТаблицы);
		СтруктураТаблиц.Вставить(Структура.ИмяТаблицы, Структура.Данные);
		
		КоличествоТаблиц = КоличествоТаблиц + 1;
	КонецЦикла;
	
	Ном = 0;
	// Обработка данных макета.
	Для Каждого ОписаниеЭлемента Из СтруктураТаблиц.ТаблицаПредопределенныеЭлементы Цикл
		
		Если ЗначениеЗаполнено(ОписаниеЭлемента.ИмяПредопределенного) Тогда
			Попытка
				СправочникСсылка = Справочники.__ПользовательскиеФункции[ОписаниеЭлемента.ИмяПредопределенного];
			Исключение
				СправочникСсылка = Неопределено;
				
				Если ВыводитьОшибки Тогда
					
					__ОбщегоНазначенияСлужебный.СообщитьПользователю(СтрШаблон(
						НСтр("ru='Не удалось найти предопределенный элемент справочника ""Пользовательские функции"" по имени %1';
						|en='Failed to find a predefined element of the directory ""User-defined functions"" named %1'"),
						ОписаниеЭлемента.ИмяПредопределенного));
				КонецЕсли;
				
			КонецПопытки;
		Иначе
			СправочникСсылка = Неопределено;
		КонецЕсли;
		
		Если СправочникСсылка = Неопределено Тогда
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
	Если ВыводитьИнформацию Тогда
		
		__ОбщегоНазначенияСлужебный.СообщитьПользователю(СтрШаблон(
			НСтр("ru='Выполнена проверка версий предопределенных элементов справочника ""Пользовательские функции"". Обновлено %1 элементов.';
			|en='Successfully checked the versions of predefined elements of the directory ""User functions"". %1 elements updated.'"),
			Строка(Ном)));
	КонецЕсли;
	
КонецПроцедуры

// Формирует структуру заголовков для элемента справочника.
//
Функция ПолучитьНазваниеПодпрограммыСПараметрами(Ссылка) Экспорт
	
	// Значения элементов структуры:
	// 
	// 	- ЗаголовокФункции: Функция МояФункция(Параметр1, Параметр2).
	// 	- НазваниеСПараметрами: МояФункция(Параметр1, Параметр2).
	// 	- ОписаниеПараметров: // Типы входных параметров: 
	// 						  // Параметр1 - 'Число'.
	// 						  // Параметр2 - 'Строка'.
	СтруктураПараметров = Новый Структура("ЗаголовокФункции, НазваниеСПараметрами, ОписаниеПараметров");
	
	ТекстНазвания = СтрШаблон("%1(", СокрЛП(Ссылка.Наименование));
	ТекстКомментария = "// Типы входных параметров: ";
	
	Для Каждого Параметр Из Ссылка.ПараметрыФункции Цикл
		
		ТекстНазвания = ТекстНазвания + СокрЛП(Параметр.Наименование);
		
		Если Параметр.НеОбязательныйДляЗаполнения Тогда
			ТекстНазвания = СтрШаблон("%1 = Неопределено", ТекстНазвания);
		КонецЕсли;
		
		Если ТипЗнч(Ссылка) = Тип("ДанныеФормыСтруктура") Тогда
			ОписаниеТипаПараметра = "";
		Иначе
			ОписаниеТипаПараметра = СокрЛП(Параметр.ТипПараметра.Получить());
		КонецЕсли;
		
		ТекстКомментария = СтрШаблон("%1%2// %3 - '%4'",
			ТекстКомментария, Символы.ПС, СокрЛП(Параметр.Наименование), ОписаниеТипаПараметра);
		
		Если Не Параметр.НомерСтроки = Ссылка.ПараметрыФункции.Количество() Тогда
			ТекстНазвания = СтрШаблон("%1, ", ТекстНазвания);
		КонецЕсли;
	КонецЦикла;
	
	ТекстНазвания = СтрШаблон("%1)", ТекстНазвания);
	
	СтруктураПараметров.ЗаголовокФункции = СтрШаблон("Функция %1", ТекстНазвания);
	СтруктураПараметров.НазваниеСПараметрами = ТекстНазвания;
	СтруктураПараметров.ОписаниеПараметров = ТекстКомментария;
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Заполняет параметры функции для переданного объекта.
// 
// Параметры:
// 	Объект - ДанныеФормыСтруктура, СправочникОбъект.__ПользовательскиеФункции.
//
Процедура ЗаполнитьПараметры(Объект) Экспорт
	
	Если Объект.Контекст = Перечисления.__КонтекстыВыполненияПользовательскихФункций.ЗагрузкаЭксель Тогда
		Объект.ПараметрыФункции.Очистить();
		ДобавитьПараметрыЗагрузкаЭксель(Объект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет добавляет параметр при отсутствии.
//
// Параметры:
//  ИмяПараметра - Строка.
//
Процедура НайтиДобавитьПараметр(Объект, ИмяПараметра)
	
	ДанныеПоиска = Объект.ПараметрыФункции.НайтиСтроки(
		Новый Структура("Наименование", ИмяПараметра));
	
	Если Не ДанныеПоиска.Количество() Тогда
		НоваяСтрока = Объект.ПараметрыФункции.Добавить();
		НоваяСтрока.Наименование = ИмяПараметра;
	КонецЕсли;
	
КонецПроцедуры

// Добавляет параметры, необходимые для контекста ЗагрузкаЭксель.
// 
Процедура ДобавитьПараметрыЗагрузкаЭксель(Объект)
	
	НайтиДобавитьПараметр(Объект, "СтрокаЗагрузки");
	НайтиДобавитьПараметр(Объект, "ДанныеЗагрузки");
	НайтиДобавитьПараметр(Объект, "СтрокаПравил");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
