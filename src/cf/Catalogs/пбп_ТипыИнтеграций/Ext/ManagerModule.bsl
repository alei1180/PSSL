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

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получить предопределенный элемент наследования настроек типа интеграции
//  Определяет родителя (предопределенный элемент второго уровня) типа интеграции, для определения настроек
//
// Параметры:
//  ТипИнтеграции - СправочникСсылка.пбп_ТипыИнтеграций - элемент, для которого нужно узнать родителя
// 
// Возвращаемое значение:
//   - СправочникСсылка.пбп_ТипыИнтеграций - предопределенный элемент второго уровня иерархии
//
Функция ПолучитьПредопределенныйЭлементНаследованияНастроекТипаИнтеграции(ТипИнтеграции) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ТипИнтеграции);
	Запрос.Текст = "ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА &Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.Каталог))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.Каталог)
	|		КОГДА &Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.FTPРесурсы))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.FTPРесурсы)
	|		КОГДА &Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.ПочтовыйКлиент))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.ПочтовыйКлиент)
	|		КОГДА &Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.COM))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.COM)
	|		КОГДА &Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.RESTAPI))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.RESTAPI)
	|		КОГДА &Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.SOAP))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.SOAP)
	|		КОГДА &Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.ВнешняяКомпонента))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.ВнешняяКомпонента)
	|		КОГДА &Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.КоманднаяСтрока))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.КоманднаяСтрока)
	|		КОГДА &Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.БрокерыСообщений))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.БрокерыСообщений)
	|		КОГДА &Ссылка В ИЕРАРХИИ (ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.ПрямоеПодключениеКБД))
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.пбп_ТипыИнтеграций.ПрямоеПодключениеКБД)
	|	КОНЕЦ КАК ПараметрыОт
	|ИЗ
	|	Справочник.пбп_ТипыИнтеграций КАК пбп_ТипыИнтеграций";
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	ПараметрыОт = Справочники.пбп_ТипыИнтеграций.ПустаяСсылка();
	Если ВыборкаРезультатаЗапроса.Следующий() Тогда
		ПараметрыОт = ВыборкаРезультатаЗапроса.ПараметрыОт;
	КонецЕсли;
	
	Возврат ПараметрыОт;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли