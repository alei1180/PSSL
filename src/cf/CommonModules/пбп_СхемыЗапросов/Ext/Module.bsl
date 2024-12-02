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

#Область ПрограммныйИнтерфейс

// Возвращает схему запроса по значению переданного индекса в пакете запросов.
//
// Параметры:
//  СхемаЗапроса - СхемаЗапроса - схема запроса.
//  ИндексЗапросаВПакете - Число - индекс запроса в пакете запросов. Если не задано, то последний запрос в пакете.
//
// Возвращаемое значение:
//  ЗапросВыбораСхемыЗапроса, ЗапросУничтоженияТаблицыСхемыЗапроса - измененный текст запроса или запрос.
//
Функция ЗапросПакетаЗапросов(Знач СхемаЗапроса, ИндексЗапросаВПакете = Неопределено) Экспорт
	Перем ЗапросПакетаЗапросов;
	
	ПакетЗапросов = СхемаЗапроса.ПакетЗапросов;
	
	Если ИндексЗапросаВПакете = Неопределено Тогда
		ИндексЗапросаВПакете = ПакетЗапросов.Количество() - 1;
	КонецЕсли;
	
	ЗапросПакетаЗапросов = ПакетЗапросов.Получить(ИндексЗапросаВПакете);
	
	Возврат ЗапросПакетаЗапросов;
КонецФункции 

// Добавляет новое поле в конец секции выборки переданного запроса
//
// Параметры:
//  Запрос - Строка, Запрос - текст запроса или запрос.
//  ВыражениеПоля - Строка - выражение поля для секции выборки.
//  ПсевдонимПоля - Строка - псевдоним поля для секции выборки.
//  ИндексЗапросаВПакете - Число - индекс запроса в пакете запросов. Если не задано, то последний запрос в пакете.
//  РасширениеЯзыкаЗапросовСКД - Булево - Истина, когда требуется дополнительно добавить поле в секцию
//  				ВЫБРАТЬ расширения языка запросов СКД.
//  ЗаменятьСуществующееПоле - Булево - Истина, когда требуется дополнительно добавить поле в запрос даже
//  				если оно было добавлено ранее. Прежнее поле будет удалено.
//
// Возвращаемое значение:
//  Строка, Запрос - измененный текст запроса или запрос.
//
Функция ДобавитьПолеВыборкиВЗапрос(Знач Запрос, ВыражениеПоля, ПсевдонимПоля = "", Знач ИндексЗапросаВПакете = Неопределено, РасширениеЯзыкаЗапросовСКД = Ложь, ЗаменятьСуществующееПоле = Ложь) Экспорт
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		ТекстЗапроса = Запрос;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда
		ТекстЗапроса = Запрос.Текст;
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректный тип параметра 1';
								|en = 'Incorrect type of parameter 1'") ;
	КонецЕсли;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	ИзменяемыйЗапрос = ЗапросПакетаЗапросов(СхемаЗапроса, ИндексЗапросаВПакете);
	
	Если ТипЗнч(ИзменяемыйЗапрос) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно добавить поля в запрос уничтожения таблицы.';
								|en = 'Cannot add fields to the table removal query.'"); 
	КонецЕсли;
	
	Колонки = ИзменяемыйЗапрос.Колонки;
	// Проверка, что колонка была добавлена ранее
	КолонкаПоПсевдониму = Колонки.Найти(ПсевдонимПоля);
	КолонкаУжеДобавлена = (КолонкаПоПсевдониму <> Неопределено);
	
	Если КолонкаУжеДобавлена И ЗаменятьСуществующееПоле Тогда
		Колонки.Удалить(Колонки.Индекс(КолонкаПоПсевдониму));
	КонецЕсли;
	
	Для ИндексОператора = 0 По ИзменяемыйЗапрос.Операторы.Количество() - 1 Цикл
		
		Для Каждого Источник Из ИзменяемыйЗапрос.Операторы[ИндексОператора].Источники Цикл
			Если ТипЗнч(Источник.Источник) = Тип("ОписаниеВременнойТаблицыСхемыЗапроса")
				И Не СтрНайти(ВыражениеПоля, Источник.Источник.Псевдоним) = 0 Тогда
				ИмяПоля = СтрЗаменить(ВыражениеПоля, Источник.Источник.Псевдоним + ".", "");
				Источник.Источник.ДоступныеПоля.Добавить(ИмяПоля);
			КонецЕсли;
		КонецЦикла;
		
		ВыбираемыеПоля = ИзменяемыйЗапрос.Операторы[ИндексОператора].ВыбираемыеПоля;
		
		НовоеПоле = ВыбираемыеПоля.Добавить(ВыражениеПоля);
		
		НоваяКолонка = Колонки.Найти(НовоеПоле);
		Если ЗначениеЗаполнено(ПсевдонимПоля) Тогда
			НоваяКолонка.Псевдоним = ПсевдонимПоля;
		КонецЕсли;
		
		// Только в первом запросе могут быть поля для СКД
		Если ИндексОператора = 0 И РасширениеЯзыкаЗапросовСКД Тогда
			ВыражениеСодержитПараметр = СтрНайти(ВыражениеПоля, "&");
			
			Если ИзменяемыйЗапрос.ПоляВыбораКомпоновкиДанных.Найти(ПсевдонимПоля) = Неопределено Тогда
				ПолеКД = ИзменяемыйЗапрос.ПоляВыбораКомпоновкиДанных.Добавить(ПсевдонимПоля); // ПолеВыбораКомпоновкиДанныхСхемыЗапроса -
				ПолеКД.Псевдоним = ПсевдонимПоля;
				ПолеКД.ИспользоватьРеквизиты = Не ВыражениеСодержитПараметр;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	НовыйТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	// Удалим "мусор" схемы запроса
	УдалитьНенужныеПоля(НовыйТекстЗапроса);
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		Запрос = НовыйТекстЗапроса;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		Запрос.Текст = НовыйТекстЗапроса;
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

// Добавляет список полей в конец секции выборки переданного запроса
//
// Параметры:
//  Запрос - Строка, Запрос - текст запроса или запрос.
//  ВыраженияПолей - СписокЗначений - выражения полей для секции выборки.
//   * Значение - Строка - Выражение поля для секции выборки
//   * Представление - Строка - Псевдоним поля, может быть не заполнен
//  ИндексЗапросаВПакете - Число - индекс запроса в пакете запросов. Если не задано, то последний запрос в пакете.
//  РасширениеЯзыкаЗапросовСКД - Булево - Истина, когда требуется дополнительно добавить поле в секцию
//  				ВЫБРАТЬ расширения языка запросов СКД.
//  ЗаменятьСуществующееПоле - Булево - Истина, когда требуется дополнительно добавить поле в запрос даже
//  				если оно было добавлено ранее. Прежнее поле будет удалено.
//
// Возвращаемое значение:
//  Строка, Запрос - измененный текст запроса или запрос.
//
Функция ДобавитьПоляВыборкиВЗапрос(Знач Запрос, ВыраженияПолей, Знач ИндексЗапросаВПакете = Неопределено, РасширениеЯзыкаЗапросовСКД = Ложь, ЗаменятьСуществующееПоле = Ложь) Экспорт
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		ТекстЗапроса = Запрос;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда
		ТекстЗапроса = Запрос.Текст;
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректный тип параметра 1';
								|en = 'Incorrect type of parameter 1'") ;
	КонецЕсли;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	ИзменяемыйЗапрос = ЗапросПакетаЗапросов(СхемаЗапроса, ИндексЗапросаВПакете);
	
	Если ТипЗнч(ИзменяемыйЗапрос) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно добавить поля в запрос уничтожения таблицы.';
								|en = 'Cannot add fields to the table removal query.'"); 
	КонецЕсли;
	
	Колонки = ИзменяемыйЗапрос.Колонки;
	
	Для Каждого Выражение Из ВыраженияПолей Цикл
		// Проверка, что колонка была добавлена ранее
		КолонкаПоПсевдониму = Колонки.Найти(Выражение.Представление);
		КолонкаУжеДобавлена = (КолонкаПоПсевдониму <> Неопределено);
		
		Если КолонкаУжеДобавлена И ЗаменятьСуществующееПоле Тогда
			Колонки.Удалить(Колонки.Индекс(КолонкаПоПсевдониму));
		КонецЕсли;
	КонецЦикла;
	
	Для ИндексОператора = 0 По ИзменяемыйЗапрос.Операторы.Количество() - 1 Цикл
		
		Для Каждого Источник Из ИзменяемыйЗапрос.Операторы[ИндексОператора].Источники Цикл
			Для Каждого Выражение Из ВыраженияПолей Цикл
				Если ТипЗнч(Источник.Источник) = Тип("ОписаниеВременнойТаблицыСхемыЗапроса")
					И Не СтрНайти(Выражение.Значение, Источник.Источник.Псевдоним) = 0 Тогда
					ИмяПоля = СтрЗаменить(Выражение.Значение, Источник.Источник.Псевдоним + ".", "");
					Источник.Источник.ДоступныеПоля.Добавить(ИмяПоля);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		ВыбираемыеПоля = ИзменяемыйЗапрос.Операторы[ИндексОператора].ВыбираемыеПоля;
		
		Для Каждого Выражение Из ВыраженияПолей Цикл
			НовоеПоле = ВыбираемыеПоля.Добавить(Выражение.Значение);
			
			НоваяКолонка = Колонки.Найти(НовоеПоле);
			Если ЗначениеЗаполнено(Выражение.Представление) Тогда
				НоваяКолонка.Псевдоним = Выражение.Представление;
			КонецЕсли;
		КонецЦикла;
		
		// Только в первом запросе могут быть поля для СКД
		Если ИндексОператора = 0 И РасширениеЯзыкаЗапросовСКД Тогда
			Для Каждого Выражение Из ВыраженияПолей Цикл
				ВыражениеСодержитПараметр = СтрНайти(Выражение.Значение, "&");
				
				Если ИзменяемыйЗапрос.ПоляВыбораКомпоновкиДанных.Найти(Выражение.Представление) = Неопределено Тогда
					ПолеКД = ИзменяемыйЗапрос.ПоляВыбораКомпоновкиДанных.Добавить(Выражение.Представление); // ПолеВыбораКомпоновкиДанныхСхемыЗапроса -
					ПолеКД.Псевдоним = Выражение.Представление;
					ПолеКД.ИспользоватьРеквизиты = Не ВыражениеСодержитПараметр;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	НовыйТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	// Удалим "мусор" схемы запроса
	УдалитьНенужныеПоля(НовыйТекстЗапроса);
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		Запрос = НовыйТекстЗапроса;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		Запрос.Текст = НовыйТекстЗапроса;
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

// Устанавливает в секцию ВЫБРАТЬ ключевые слова "ПЕРВЫЕ N".
//
// Параметры:
//  Запрос - Строка, Запрос - текст запроса или запрос.
//  КоличествоПолучаемыхЗаписей - Число - количество первых записей, которые необходимо выбрать.
//  							- Неопределено - ключевые слова "ПЕРВЫЕ N" будут исключены из секции ВЫБРАТЬ.
//  ИндексЗапросаВПакете - Число - индекс запроса в пакете запросов. Если не задано, то последний запрос в пакете.
//
// Возвращаемое значение:
//  Строка, Запрос - измененный текст запроса или запрос.
//
Функция УстановитьКоличествоПолучаемыхЗаписей(Знач Запрос, Знач КоличествоПолучаемыхЗаписей, Знач ИндексЗапросаВПакете = Неопределено) Экспорт
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		ТекстЗапроса = Запрос;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		ТекстЗапроса = Запрос.Текст;
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректный тип параметра 1';
								|en = 'Incorrect type of parameter 1'") ;
	КонецЕсли;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	ИзменяемыйЗапрос = ЗапросПакетаЗапросов(СхемаЗапроса, ИндексЗапросаВПакете);
	
	Если ТипЗнч(ИзменяемыйЗапрос) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно добавить количество выбираемых записей в запрос уничтожения таблицы.';
								|en = 'Cannot add the number of selected entries to the table removal query.'"); 
	КонецЕсли;
	
	ОператорВыбрать = ИзменяемыйЗапрос.Операторы[0];
	
	ОператорВыбрать.КоличествоПолучаемыхЗаписей = КоличествоПолучаемыхЗаписей;
	
	ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		Запрос = ТекстЗапроса;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		Запрос.Текст = ТекстЗапроса;
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

// Устанавливает в секцию ВЫБРАТЬ ключевое слово "РАЗРЕШЕННЫЕ".
//
// Параметры:
//  Запрос - Строка, Запрос - текст запроса или запрос.
//  ВыбиратьРазрешенные - Булево - признак, выбирать ли только разрешенные записи.
//  			Истина - будет добавлено ключевое слово "РАЗРЕШЕННЫЕ" в секцию ВЫБРАТЬ.
//  			Ложь   - будет исключено ключевое слово "РАЗРЕШЕННЫЕ" в секцию ВЫБРАТЬ.
//  ИндексЗапросаВПакете - Число - индекс запроса в пакете запросов. Если не задано, то последний запрос в пакете.
//
// Возвращаемое значение:
//  Строка, Запрос - измененный текст запроса или запрос.
//
Функция УстановитьВыборкуРазрешенныхЗаписей(Знач Запрос, Знач ВыбиратьРазрешенные, Знач ИндексЗапросаВПакете = Неопределено) Экспорт
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		ТекстЗапроса = Запрос;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		ТекстЗапроса = Запрос.Текст;
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректный тип параметра 1';
								|en = 'Incorrect type of parameter 1'") ;
	КонецЕсли;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	ИзменяемыйЗапрос = ЗапросПакетаЗапросов(СхемаЗапроса, ИндексЗапросаВПакете);
	
	Если ТипЗнч(ИзменяемыйЗапрос) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно добавить количество выбираемых записей в запрос уничтожения таблицы.';
								|en = 'Cannot add the number of selected entries to the table removal query.'"); 
	КонецЕсли;
	
	ИзменяемыйЗапрос.ВыбиратьРазрешенные = ВыбиратьРазрешенные;
	
	ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		Запрос = ТекстЗапроса;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		Запрос.Текст = ТекстЗапроса;
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

Функция УстановитьВыборкуРазрешенныхЗаписейВоВсемЗапросе(Знач Запрос, Знач ВыбиратьРазрешенные) Экспорт
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		ТекстЗапроса = Запрос;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		ТекстЗапроса = Запрос.Текст;
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректный тип параметра 1';
								|en = 'Incorrect type of parameter 1'") ;
	КонецЕсли;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	ПакетЗапросов = СхемаЗапроса.ПакетЗапросов;
	КоличествоПакетов = ПакетЗапросов.Количество();
	Если КоличествоПакетов > 0 Тогда
		Для ИндексЗапросаВПакете = 0 По КоличествоПакетов - 1 Цикл
			ИзменяемыйЗапрос = ПакетЗапросов.Получить(ИндексЗапросаВПакете);
			Если ТипЗнч(ИзменяемыйЗапрос) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
				Продолжить;
			КонецЕсли;
			ИзменяемыйЗапрос.ВыбиратьРазрешенные = ВыбиратьРазрешенные;
		КонецЦикла;
	КонецЕсли;
	
	ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		Запрос = ТекстЗапроса;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		Запрос.Текст = ТекстЗапроса;
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

// Добавляет выражение условия в параметры виртуальных таблиц
//
// Параметры:
//  Запрос - Строка, Запрос - текст запроса или запрос.
//  ВыражениеУсловия - Строка - выражение условия для секции параметров виртуальной таблицы.
//  ИндексЗапросаВПакете - Число - индекс запроса в пакете запросов. Если не задано, то последний запрос в пакете.
//
// Возвращаемое значение:
//  Строка, Запрос - измененный текст запроса или запрос.
//
Функция ДобавитьУсловиеВЗапрос(Знач Запрос, ВыражениеУсловия, Знач ИндексЗапросаВПакете = Неопределено) Экспорт
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		ТекстЗапроса = Запрос;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		ТекстЗапроса = Запрос.Текст;
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректный тип параметра 1';
								|en = 'Incorrect type of parameter 1'") ;
	КонецЕсли;
	
	Если Не ТипЗнч(ВыражениеУсловия) = Тип("Строка") Тогда
		ТекстЗапроса = Запрос;
		ВызватьИсключение НСтр("ru = 'Некорректный тип параметра 2';
								|en = 'Incorrect type of parameter 2'") ;
	КонецЕсли;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	ИзменяемыйЗапрос = ЗапросПакетаЗапросов(СхемаЗапроса, ИндексЗапросаВПакете);
	
	Если ТипЗнч(ИзменяемыйЗапрос) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно добавить параметр в запрос уничтожения таблицы.';
								|en = 'Cannot add parameter to the table removal query.'"); 
	КонецЕсли;
	
	// Подстановка выражения во все источники с параметрами
	ЧастиВыражения = Новый Массив;
	Для Каждого ОператорЗапроса Из ИзменяемыйЗапрос.Операторы Цикл 
		Для Каждого ИсточникОператора Из ОператорЗапроса.Источники Цикл
			
			ЧастиВыражения.Очистить();
			
			Подзапрос = ИсточникОператора.Источник;
			
			Если ТипЗнч(Подзапрос) = Тип("ВложенныйЗапросСхемыЗапроса") Тогда
				
				ТекстЗапросаИсточника = Подзапрос.Запрос.ПолучитьТекстЗапроса();
				ТекстЗапросаИсточника = ДобавитьУсловиеВЗапрос(ТекстЗапросаИсточника, ВыражениеУсловия);
				Подзапрос.Запрос.УстановитьТекстЗапроса(ТекстЗапросаИсточника);
				
			ИначеЕсли ТипЗнч(Подзапрос) = Тип("ТаблицаСхемыЗапроса") Тогда
				
				ПараметрыИсточника = Подзапрос.Параметры;
				КоличествоПараметров = ПараметрыИсточника.Количество();
				
				Если КоличествоПараметров = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				// В виртуальных таблицах РБ 3 параметр с конца используется для условий по измерениям.
				Если СтрНачинаетсяС(ИсточникОператора.Источник.ИмяТаблицы, "РегистрБухгалтерии") Тогда
					ПоследнийПараметрИсточника = ПараметрыИсточника[КоличествоПараметров - 3];
				Иначе
					ПоследнийПараметрИсточника = ПараметрыИсточника[КоличествоПараметров - 1];
				КонецЕсли;
				
				ИсходноеВыражение = Строка(ПоследнийПараметрИсточника.Выражение);
				Если ЗначениеЗаполнено(ИсходноеВыражение) Тогда
					ЧастиВыражения.Добавить(ИсходноеВыражение);
				КонецЕсли;
				ЧастиВыражения.Добавить(ВыражениеУсловия);
				
				ПоследнийПараметрИсточника.Выражение = Новый ВыражениеСхемыЗапроса(СтрСоединить(ЧастиВыражения, " И "));
				
			КонецЕсли;
				
		КонецЦикла;
	КонецЦикла;
	
	ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	// Удалим "мусор" схемы запроса
	Для НомерПоля = 1 По 9 Цикл 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, " КАК Поле" + НомерПоля, "");
	КонецЦикла;
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		Запрос = ТекстЗапроса;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		Запрос.Текст = ТекстЗапроса;
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

// Добавляет новое соединение с источником данных.
//
// Параметры:
//  Запрос - Строка, Запрос - текст запроса или запрос.
//  ПсевдонимИсточника - Строка - псевдоним источника, к которому необходимо присоединить таблицу.
//  ОписаниеСоединения - см. ОписаниеСоединения
//  ИндексЗапросаВПакете - Число - индекс запроса в пакете запросов. Если не задано, то последний запрос в пакете.
//  ЗаменятьСуществующееСоединение - Булево - если Истина, то существующее соединение удаляется, если Ложь - вызывается исключение.
//
// Возвращаемое значение:
//  Строка, Запрос - измененный текст запроса или запрос.
//
Функция ДобавитьСоединениеВЗапрос(Знач Запрос, ПсевдонимИсточника, ОписаниеСоединения,
									Знач ИндексЗапросаВПакете = Неопределено, ЗаменятьСуществующееСоединение = Ложь) Экспорт
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		ТекстЗапроса = Запрос;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		ТекстЗапроса = Запрос.Текст;
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректный тип параметра 1';
								|en = 'Incorrect type of parameter 1'");
	КонецЕсли;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	ИзменяемыйЗапрос = ЗапросПакетаЗапросов(СхемаЗапроса, ИндексЗапросаВПакете);
	
	Если ТипЗнч(ИзменяемыйЗапрос) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
		ВызватьИсключение НСтр("ru = 'Невозможно добавить поля в запрос уничтожения таблицы.';
								|en = 'Cannot add fields to the table removal query.'"); 
	КонецЕсли;
	
	Для Каждого ТекОператор Из ИзменяемыйЗапрос.Операторы Цикл
		
		Источник = ТекОператор.Источники.НайтиПоПсевдониму(ПсевдонимИсточника);
		Если Источник = Неопределено Тогда
			
			ТекстИсключения = НСтр("ru = 'В запросе отсутствует источник с псевдонимом ""%1""';
									|en = 'The query does not contain the ""%1"" alias'");
			ТекстИсключения = СтрШаблон(ТекстИсключения, ПсевдонимИсточника);
			
			ВызватьИсключение ТекстИсключения;
			
		КонецЕсли;
		
		Соединение = Источник.Соединения.НайтиПоИмени(ОписаниеСоединения.ОписаниеТаблицы.ИмяТаблицы);
		Если Не Соединение = Неопределено
			И Не ЗаменятьСуществующееСоединение Тогда
			
			ТекстИсключения = НСтр("ru = 'В запросе уже присутствует соединение с таблицей ""%1""';
									|en = 'The query already contains the ""%1"" table connection'");
			ТекстИсключения = СтрШаблон(ТекстИсключения, ОписаниеСоединения.ОписаниеТаблицы.ИмяТаблицы);
			
			ВызватьИсключение ТекстИсключения;
			
		ИначеЕсли Не Соединение = Неопределено
			И ЗаменятьСуществующееСоединение Тогда
			Источник.Соединения.Удалить(Источник.Соединения.Индекс(Соединение));
		КонецЕсли;
		
		Соединение = Источник.Соединения.НайтиПоПсевдониму(ОписаниеСоединения.ОписаниеТаблицы.ПсевдонимТаблицы);
		Если Не Соединение = Неопределено
			И Не ЗаменятьСуществующееСоединение Тогда
			
			ТекстИсключения = НСтр("ru = 'В запросе уже присутствует соединение с псевдонимом ""%1""';
									|en = 'The query already contains the ""%1"" alias connection'");
			ТекстИсключения = СтрШаблон(ТекстИсключения, ОписаниеСоединения.ОписаниеТаблицы.ПсевдонимТаблицы);
			
			ВызватьИсключение ТекстИсключения;
			
		ИначеЕсли Не Соединение = Неопределено
			И ЗаменятьСуществующееСоединение Тогда
			Источник.Соединения.Удалить(Источник.Соединения.Индекс(Соединение));
		КонецЕсли;
		
		ИсточникСоединения = ТекОператор.Источники.НайтиПоИмени(ОписаниеСоединения.ОписаниеТаблицы.ИмяТаблицы);
		Если ИсточникСоединения = Неопределено Тогда
			
			// Если таблица не описана в запросе, необходимо добавить ее описание
			Если ИзменяемыйЗапрос.ДоступныеТаблицы.Найти(ОписаниеСоединения.ОписаниеТаблицы.ИмяТаблицы) = Неопределено Тогда
				
				Если Не ЗначениеЗаполнено(ОписаниеСоединения.ОписаниеТаблицы.ТипТаблицы) Тогда
					ВызватьИсключение НСтр("ru = 'Не задан тип присоединяемой таблицы.';
											|en = 'Type of the table to attach is not specified.'");
				КонецЕсли;
				
				Если ОписаниеСоединения.ОписаниеТаблицы.ТипТаблицы = Тип("ВложеннаяТаблицаСхемыЗапроса") Тогда
					
					Если Не ЗначениеЗаполнено(ОписаниеСоединения.ОписаниеТаблицы.ТекстЗапроса) Тогда
						ВызватьИсключение НСтр("ru = 'Не задан текст запроса присоединяемой таблицы.';
												|en = 'Query text of the table to attach is not specified.'");
					КонецЕсли;
					
					ИсточникСоединения =
						ТекОператор.Источники.Добавить(
							ОписаниеСоединения.ОписаниеТаблицы.ТипТаблицы,
							ОписаниеСоединения.ОписаниеТаблицы.ПсевдонимТаблицы);
					
					ИсточникСоединения.Источник.Запрос.УстановитьТекстЗапроса(ОписаниеСоединения.ОписаниеТаблицы.ТекстЗапроса);
					
				ИначеЕсли ОписаниеСоединения.ОписаниеТаблицы.ТипТаблицы = Тип("ОписаниеВременнойТаблицыСхемыЗапроса") Тогда
					
					Если Не ЗначениеЗаполнено(ОписаниеСоединения.ОписаниеТаблицы.ДоступныеПоля) Тогда
						ВызватьИсключение НСтр("ru = 'Не задано описание полей присоединяемой таблицы.';
												|en = 'Field details of the table to attach are not specified.'");
					КонецЕсли;
					
					ИсточникСоединения =
						ТекОператор.Источники.Добавить(
							ОписаниеСоединения.ОписаниеТаблицы.ТипТаблицы,
							ОписаниеСоединения.ОписаниеТаблицы.ИмяТаблицы,
							ОписаниеСоединения.ОписаниеТаблицы.ПсевдонимТаблицы);
					
					Для Каждого ТекПоле Из ОписаниеСоединения.ОписаниеТаблицы.ДоступныеПоля Цикл
						ИсточникСоединения.Источник.ДоступныеПоля.Добавить(ТекПоле);
					КонецЦикла;
					
				Иначе
					ВызватьИсключение НСтр("ru = 'Указано неправильное имя присоединяемой таблицы.';
											|en = 'Incorrect name of the table to attach is specified.'");
				КонецЕсли;
				
			Иначе
				ИсточникСоединения =
					ТекОператор.Источники.Добавить(
						ОписаниеСоединения.ОписаниеТаблицы.ИмяТаблицы,
						ОписаниеСоединения.ОписаниеТаблицы.ПсевдонимТаблицы);
			КонецЕсли;
			
			ИсточникСоединения.Соединения.Очистить();
			
		КонецЕсли;
		
		Если Источник.Соединения.Добавить(ИсточникСоединения, ОписаниеСоединения.Условие) Тогда
			Соединение = Источник.Соединения.НайтиПоПсевдониму(ОписаниеСоединения.ОписаниеТаблицы.ПсевдонимТаблицы);
			Если ЗначениеЗаполнено(ОписаниеСоединения.ТипСоединения) Тогда
				Соединение.ТипСоединения = ОписаниеСоединения.ТипСоединения;
			КонецЕсли;
		Иначе
			ВызватьИсключение НСтр("ru = 'Не удалось добавить соединение.';
									|en = 'Cannot add the connection.'");
		КонецЕсли;
		
	КонецЦикла;
	
	НовыйТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		Запрос = НовыйТекстЗапроса;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		Запрос.Текст = НовыйТекстЗапроса;
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

// Удаляет поля из запроса.
//
// Параметры:
//  Запрос - Строка, Запрос - текст запроса или запрос.
//  ПсевдонимыПолей - Строка, Массив - строка псевдонимов полей, разделенных запятой, либо массив псевдонимов полей.
//  ИндексЗапросаВПакете - Число - индекс запроса в пакете запросов. Если не задано, то удаляется во всех запросах пакета.
//
// Возвращаемое значение:
//  Строка, Запрос - измененный текст запроса или запрос.
//
Функция УдалитьПоляИзЗапроса(Знач Запрос, ПсевдонимыПолей, Знач ИндексЗапросаВПакете = Неопределено) Экспорт
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		ТекстЗапроса = Запрос;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		ТекстЗапроса = Запрос.Текст;
	Иначе
		ВызватьИсключение НСтр("ru = 'Некорректный тип параметра 1';
								|en = 'Incorrect type of parameter 1'") ;
	КонецЕсли;
	
	СхемаЗапроса = Новый СхемаЗапроса;
	
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);
	
	Если ТипЗнч(ПсевдонимыПолей) = Тип("Строка") Тогда
		УдаляемыеПоля = СтрРазделить(ПсевдонимыПолей, ",", Ложь);
	Иначе
		УдаляемыеПоля = ПсевдонимыПолей;
	КонецЕсли;
	
	Если ИндексЗапросаВПакете = Неопределено Тогда
		ИзменяемыеЗапросы = СхемаЗапроса.ПакетЗапросов;
	Иначе
		ИзменяемыеЗапросы = Новый Массив;
		ИзменяемыеЗапросы.Добавить(ЗапросПакетаЗапросов(СхемаЗапроса, ИндексЗапросаВПакете));
	КонецЕсли;
	
	Для Каждого ИзменяемыйЗапрос Из ИзменяемыеЗапросы Цикл
		
		Если ТипЗнч(ИзменяемыйЗапрос) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
			Продолжить;
		КонецЕсли;
		
		Колонки = ИзменяемыйЗапрос.Колонки;
		
		Для Каждого ТекПоле Из УдаляемыеПоля Цикл
			
			Поле = Колонки.Найти(ТекПоле);
			Если Не Поле = Неопределено Тогда
				Колонки.Удалить(Колонки.Индекс(Поле));
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	НовыйТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	
	Если ТипЗнч(Запрос) = Тип("Строка") Тогда
		Запрос = НовыйТекстЗапроса;
	ИначеЕсли ТипЗнч(Запрос) = Тип("Запрос") Тогда 
		Запрос.Текст = НовыйТекстЗапроса;
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

#Область Конструкторы

// Возвращает описание добавляемого соединения.
//
// Параметры:
//  ОписаниеТаблицы - см. ОписаниеТаблицы
//  Условие - Строка - условие соединения
//  ТипСоединения - Неопределено, ТипСоединенияСхемыЗапроса - тип соединения
//
// Возвращаемое значение:
//  Структура:
//  *ОписаниеТаблицы - см. ОписаниеТаблицы
//  *Условие - Строка
//  *ТипСоединения - ТипСоединенияСхемыЗапроса
//
Функция ОписаниеСоединения(ОписаниеТаблицы, Условие, ТипСоединения = Неопределено) Экспорт
	
	Описание = Новый Структура;
	Описание.Вставить("ОписаниеТаблицы", ОписаниеТаблицы);
	Описание.Вставить("Условие", Условие);
	Описание.Вставить("ТипСоединения", ТипСоединения);
	
	Возврат Описание;
	
КонецФункции

// Описание таблицы схемы запроса
// 
// Параметры:
//  ТипТаблицы - Тип
//  ИмяТаблицы - Строка
//  ПсевдонимТаблицы - Строка
//  ДоступныеПоля - Строка, Массив из Строка - доступные поля
//  ТекстЗапроса - Строка
// 
// Возвращаемое значение:
//  Структура - Описание таблицы:
//  *ТипТаблицы - Тип
//  *ИмяТаблицы - Строка
//  *ПсевдонимТаблицы - Строка
//  *ДоступныеПоля - Массив из Строка
//  *ТекстЗапроса - Строка
//
Функция ОписаниеТаблицы(ТипТаблицы, ИмяТаблицы, ПсевдонимТаблицы, ДоступныеПоля = Неопределено, ТекстЗапроса = Неопределено) Экспорт
	
	Описание = Новый Структура;
	Описание.Вставить("ТипТаблицы",       ТипТаблицы);
	Описание.Вставить("ИмяТаблицы",       ИмяТаблицы);
	Описание.Вставить("ПсевдонимТаблицы", ПсевдонимТаблицы);
	Описание.Вставить("ТекстЗапроса",     ТекстЗапроса);
	
	Если ТипЗнч(ДоступныеПоля) = Тип("Строка") Тогда
		Описание.Вставить(
			"ДоступныеПоля",
			пбп_ПереадресацияКлиентСервер.РазложитьСтрокуВМассивПодстрок(
				ДоступныеПоля, ",", Истина, Истина));
	Иначе
		Описание.Вставить("ДоступныеПоля", ДоступныеПоля);
	КонецЕсли;
	
	Возврат Описание;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьНенужныеПоля(ТекстЗапроса)

	// Удалим "мусор" схемы запроса
	НомерПоля = 1;
	ИскомаяПодстрока = " КАК Поле" + НомерПоля;
	НайденоМусорноеПоле = СтрНайти(ТекстЗапроса, ИскомаяПодстрока) > 0;
	МаксимальноеКоличествоПолей = 20;
	Пока НайденоМусорноеПоле И НомерПоля < МаксимальноеКоличествоПолей Цикл 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ИскомаяПодстрока, "");
		
		НомерПоля = НомерПоля + 1;
		ИскомаяПодстрока = " КАК Поле" + НомерПоля;
		НайденоМусорноеПоле = СтрНайти(ТекстЗапроса, ИскомаяПодстрока) > 0;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
