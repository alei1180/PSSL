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

// Получить структуру параметров входа
//
// Параметры:
//  ИнтеграционныйПоток - СправочникСсылка.пбп_ИнтеграционныеПотоки - ссылка на поток, параметры которого получаем.
//  ЗаполнятьПоУмолчанию - Булево - добавлять ли в возвращаемую структуру значения по умолчанию
//    - Ложь - возвращает структуру вида ИмяПараметра<Строка>:ТипЗначения<ПеречислениеСсылка.пбп_ТипыJSON>
//    - Истина - возвращает структуру вида ИмяПараметра<Строка>:ЗначениеПоУмолчанию<Строка>
//
// Возвращаемое значение:
//   - Структура
//
Функция ПолучитьСтруктуруПараметровВхода(ИнтеграционныйПоток, ЗаполнятьПоУмолчанию = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	пбп_ИнтеграционныеПотокиПараметрыВхода.Имя КАК Имя,
	|	пбп_ИнтеграционныеПотокиПараметрыВхода.Тип КАК Тип,
	|	пбп_ИнтеграционныеПотокиПараметрыВхода.ПараметрURL КАК ПараметрURL,
	|	пбп_ИнтеграционныеПотокиПараметрыВхода.ЗначениеПоУмолчанию КАК ЗначениеПоУмолчанию,
	|	пбп_ИнтеграционныеПотокиПараметрыВхода.ПолеОбъекта КАК ПолеОбъекта
	|ИЗ
	|	Справочник.пбп_ИнтеграционныеПотоки.ПараметрыВхода КАК пбп_ИнтеграционныеПотокиПараметрыВхода
	|ГДЕ
	|	пбп_ИнтеграционныеПотокиПараметрыВхода.Ссылка = &ИнтеграционныйПоток";
	
	Запрос.УстановитьПараметр("ИнтеграционныйПоток", ИнтеграционныйПоток);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Результат = Новый Структура;
	
	Пока Выборка.Следующий() Цикл
		Имя = Выборка.Имя; 
		
		Если ЗаполнятьПоУмолчанию Тогда
			Результат.Вставить(Имя, ПривестиЗначениеПоУмолчаниюREST(Выборка.ЗначениеПоУмолчанию, Выборка.Тип));
		Иначе
			Результат.Вставить(Имя, Выборка.Тип);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Получает структуру параметров метода интеграции со значениями по умолчанию
//
// Параметры:
//  Значение - СправочникСсылка.пбп_МетодыИнтеграции - ссылка на метод, параметры которого получаем.
//  ТипJSON - ПеречислениеСсылка.пбп_ТипыJSON - добавлять ли в возвращаемую структуру значения по умолчанию
//
// Возвращаемое значение:
//   - Строка - приведенное к JSON поле типа
//
Функция ПривестиЗначениеПоУмолчаниюREST(Значение, ТипJSON) Экспорт
	
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Если ТипJSON = Перечисления.пбп_ТипыJSON.Строка Тогда
			Возврат "";
		ИначеЕсли ТипJSON = Перечисления.пбп_ТипыJSON.Число Тогда
			Возврат 0;
		Иначе
			Возврат "null";
		КонецЕсли;
	КонецЕсли;
	
	Если ТипJSON = Перечисления.пбп_ТипыJSON.Булево Тогда
		ПреобразованноеЗначение = ?(Значение, "true", "false");
	ИначеЕсли ТипJSON = Перечисления.пбп_ТипыJSON.Дата Тогда
		ПреобразованноеЗначение = Формат(Значение, "ДФ=yyyy-MM-dd");
	ИначеЕсли ТипJSON = Перечисления.пбп_ТипыJSON.Число Тогда
		ПреобразованноеЗначение = Формат(Значение, "ЧГ=0");
	ИначеЕсли ТипJSON = Перечисления.пбп_ТипыJSON.Строка Тогда
		ПреобразованноеЗначение = Значение;
	Иначе
		ПреобразованноеЗначение = "";
	КонецЕсли;
	
	Возврат ПреобразованноеЗначение;
	
КонецФункции

#КонецОбласти

#КонецЕсли