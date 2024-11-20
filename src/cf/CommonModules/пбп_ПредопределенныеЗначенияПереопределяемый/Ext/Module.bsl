﻿
#Область ПрограммныйИнтерфейс

// Инициализирует предопределенные значения из таблицы.
//
// Параметры:
//  Менеджер - СправочникМенеджер, ПланВидовХарактеристикМенеджер - менеджер объекта.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица предопределенных элементов.
//
Функция ТаблицаПредопределенныхЭлементов(Менеджер) Экспорт
	
	Колонки = КолонкиПредопределенныхЭлементов(Менеджер);
	
	Выражение = пбп_ПредопределенныеЗначенияПовтИсп.ФункцииСозданияТаблицПредопределенныхЭлементов()
		.Получить(ТипЗнч(Менеджер));
		
	Таблица = Новый ТаблицаЗначений;
	
	Если Не ЗначениеЗаполнено(Выражение) Тогда
		Возврат Таблица;
	КонецЕсли;
	
	СоздатьКолонкиТаблицыПредопределенныхЭлементов(Колонки, Таблица);
	
	Параметры = Новый Массив;
	Параметры.Добавить(Таблица);
	
	пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(Выражение, Параметры);
	
	Возврат Параметры[0];
	
КонецФункции

//  Инициализирует таблицу значений для конфликтных элементов.
//
// Параметры:
//  Менеджер		- СправочникМенеджер, ПланВидовХарактеристикМенеджер - менеджер объекта.
//  ИсходнаяТаблица - ТаблицаЗначений - Пустая таблица каркас,
//                    см. пбп_ПредопределенныеЗначенияПереопределяемый.ТаблицаПредопределенныхЭлементов
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица конфликтных элементов.
//
Функция ТаблицаКонфликтныхЭлементов(Менеджер, ИсходнаяТаблица = Неопределено) Экспорт
	
	Если ИсходнаяТаблица = Неопределено Тогда
		ИсходнаяТаблица = ТаблицаПредопределенныхЭлементов(Менеджер);
	КонецЕсли;
	
	ИсходнаяТаблица.Колонки.Добавить("Служебный_ДублированиеИдентификаторов", Новый ОписаниеТипов("Булево"));
	
	Возврат ИсходнаяТаблица;
	
КонецФункции

#Область ЗаполнениеДанных

// Заполняет таблицу предопределенных элементов справочника
//  ПланыВидовХарактеристикСсылка.пбп_ПредопределенныеЗначения.
//
// Параметры:
//  Таблица	 - ТаблицаЗначений - Таблица предопределенных элементов.
//
Процедура ПредопределенныеЗначения(Таблица) Экспорт
	
	ОписаниеЧисло = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10,0));
	
	// Добавление
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Интеграции";
	НоваяНастройка.ИдентификаторНастройки = "Интеграции";
	НоваяНастройка.ЭтоГруппа = Истина;
	НоваяНастройка.УровеньИерархии = 0;
	
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Интеграции локал";
	НоваяНастройка.ИдентификаторНастройки = "Интеграции_локал";
	НоваяНастройка.ЭтоГруппа = Истина;
	НоваяНастройка.ИдентификаторРодитель = "Интеграции";
	НоваяНастройка.УровеньИерархии = 1;
	
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Тестовая";
	НоваяНастройка.ИдентификаторНастройки = "Тестовая";
	НоваяНастройка.ЭтоГруппа = Истина;
	
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Количество дней хранения истории интеграции";
	НоваяНастройка.ИдентификаторНастройки = "КолДнейХраненияИсторииИнтеграции";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Ложь;
	НоваяНастройка.ТипЗначения = ОписаниеЧисло;
	НоваяНастройка.ИдентификаторРодитель = "Интеграции";
	
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Количество дней хранения ошибок истории интеграции";
	НоваяНастройка.ИдентификаторНастройки = "КолДнейХраненияОшибокИсторииИнтеграции";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Ложь;
	НоваяНастройка.ТипЗначения = ОписаниеЧисло;
	НоваяНастройка.ИдентификаторРодитель = "Интеграции";
	
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Тест булево";
	НоваяНастройка.ИдентификаторНастройки = "Тест_булево";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Ложь;
	НоваяНастройка.ТипЗначения = Новый ОписаниеТипов("Булево");
	НоваяНастройка.ИдентификаторРодитель = "Тестовая";
	
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Тест список";
	НоваяНастройка.ИдентификаторНастройки = "Тест_список";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Истина;
	НоваяНастройка.ТипЗначения = Новый ОписаниеТипов("Строка");
	// КонецДобавления
	
КонецПроцедуры

// Заполняет таблицу предопределенных элементов справочника СправочникСсылка.пбп_ИнтегрируемыеСистемы.
//
// Параметры:
//  Таблица	 - ТаблицаЗначений - Таблица предопределенных элементов.
//
Процедура ПредопределенныеЗначенияИнтегрируемыеСистемы(Таблица) Экспорт
	
	// Добавление
	НоваяСистема = Таблица.Добавить();
	НоваяСистема.Наименование = "Система N";
	НоваяСистема.ИдентификаторНастройки = "СистемаN";
	
	НоваяСистема = Таблица.Добавить();
	НоваяСистема.Наименование = "Rabbit Mq";
	НоваяСистема.ИдентификаторНастройки = "RabbitMq";
	
	НоваяСистема = Таблица.Добавить();
	НоваяСистема.Наименование = "Kafka";
	НоваяСистема.ИдентификаторНастройки = "Kafka";
	
	НоваяСистема = Таблица.Добавить();
	НоваяСистема.Наименование = "Active directory";
	НоваяСистема.ИдентификаторНастройки = "ActiveDirectory";
	// КонецДобавления
	
КонецПроцедуры

// Заполняет таблицу предопределенных элементов справочника СправочникСсылка.пбп_ИнтеграционныеПотоки.
//
// Параметры:
//  Таблица	 - ТаблицаЗначений - Таблица предопределенных элементов.
//
Процедура ПредопределенныеЗначенияИнтеграционныеПотоки(Таблица) Экспорт
	
	// Добавление
	НовыйМетод = Таблица.Добавить();
	НовыйМетод.Наименование = "Интеграционный поток системы N";
	НовыйМетод.ИдентификаторНастройки = "ИнтеграционныйПотокСистемыN";
	НовыйМетод.НаправлениеПотока = Перечисления.пбп_НаправленияИнтеграционныхПотоков.Исходящий;
	// КонецДобавления
	
КонецПроцедуры

// Заполняет таблицу предопределенных элементов справочника СправочникСсылка.пбп_НастройкиИнтеграции.
//
// Параметры:
//  Таблица	 - ТаблицаЗначений - Таблица предопределенных элементов.
//
Процедура ПредопределенныеЗначенияНастройкиИнтеграции(Таблица) Экспорт
	
	// Добавление
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Интеграция с системой N";
	НоваяНастройка.ИдентификаторНастройки = "ИнтеграцияССистемойN";
	
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Rabbit Mq";
	НоваяНастройка.ИдентификаторНастройки = "RabbitMq";
	НоваяНастройка.ИнтегрируемаяСистема = пбп_ИнтеграцииСлужебный.ИнтегрируемаяСистема("RabbitMq");
	НоваяНастройка.ТипИнтеграции = Справочники.пбп_ТипыИнтеграций.RabbitMq;
	НоваяНастройка.ТипАвторизации = Перечисления.пбп_ТипыАвторизации.Базовая;
	
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Simple Kafka";
	НоваяНастройка.ИдентификаторНастройки = "SimpleKafka";
	НоваяНастройка.ИнтегрируемаяСистема = пбп_ИнтеграцииСлужебный.ИнтегрируемаяСистема("Kafka");
	НоваяНастройка.ТипИнтеграции = Справочники.пбп_ТипыИнтеграций.Kafka;
	НоваяНастройка.ТипАвторизации = Перечисления.пбп_ТипыАвторизации.Базовая;
	
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Active directory";
	НоваяНастройка.ИдентификаторНастройки = "ActiveDirectory";
	НоваяНастройка.СтрокаПодключения = "Provider=""ADsDSOObject""";
	НоваяНастройка.ИнтегрируемаяСистема = пбп_ИнтеграцииСлужебный.ИнтегрируемаяСистема("ActiveDirectory");
	НоваяНастройка.ТипИнтеграции = Справочники.пбп_ТипыИнтеграций.COM;
	НоваяНастройка.ТипАвторизации = Перечисления.пбп_ТипыАвторизации.Базовая;
	НоваяНастройка.ИмяОбъекта = "ADODB.Connection";
	// КонецДобавления
	
КонецПроцедуры

// Заполняет таблицу предопределенных элементов справочника СправочникСсылка.пбп_ТипСоответствияОбъектовИБ.
//
// Параметры:
//  Таблица	 - ТаблицаЗначений - Таблица предопределенных элементов.
//
Процедура ПредопределенныеЗначенияТипСоответствияОбъектовИБ(Таблица) Экспорт
	
	// Добавление
	НоваяНастройка = Таблица.Добавить();
	НоваяНастройка.Наименование = "Тест";
	НоваяНастройка.ИдентификаторНастройки = "Тест";
	// КонецДобавления
	
КонецПроцедуры

#КонецОбласти

// Возвращает колонки таблицы предопределенных элементов.
//
// Параметры:
//  Менеджер - СправочникМенеджер, ПланВидовХарактеристикМенеджер - менеджер объекта.
// 
// Возвращаемое значение:
//  Структура - Где ключ имя колонки, значение описание типов колонки
//
Функция КолонкиПредопределенныхЭлементов(Менеджер) Экспорт
	
	Выражение = пбп_ПредопределенныеЗначенияПовтИсп.ФункцииПолученияКолонокПредопределенныхЭлементов()
		.Получить(ТипЗнч(Менеджер));
	
	Если Не ЗначениеЗаполнено(Выражение) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Колонки = ОбщиеКолонки(Менеджер);
	
	Параметры = Новый Массив;
	Параметры.Добавить(Менеджер);
	
	ДопКолонки = пбп_ОбщегоНазначенияСлужебный.ВычислитьВБезопасномРежиме(Выражение);
	
	пбп_ОбщегоНазначенияСлужебныйКлиентСервер.ДополнитьСтруктуру(Колонки, ДопКолонки);
	
	Возврат Колонки;
	
КонецФункции

#Область СтруктурыКолонокТаблиц

// Возвращает колонки предопределенные значения
// 
// Возвращаемое значение:
//  Структура - Где ключ имя колонки, значение описание типов колонки
//
Функция КолонкиПредопределенныеЗначения() Экспорт
	
	Колонки = Новый Структура;
	
	ОписаниеБулево = Новый ОписаниеТипов("Булево");
	
	// Добавление
	Колонки.Вставить("Пароль", ОписаниеБулево);
	Колонки.Вставить("СписокЗначений", ОписаниеБулево);
	Колонки.Вставить("ТипЗначения", Новый ОписаниеТипов("ОписаниеТипов"));
	// КонецДобавления
	
	Возврат Колонки;
	
КонецФункции

// Возвращает колонки интегрируемые системы
// 
// Возвращаемое значение:
//  Структура - Где ключ имя колонки, значение описание типов колонки
//
Функция КолонкиИнтегрируемыеСистемы() Экспорт
	
	Колонки = Новый Структура;
	
	// Добавление
	
	// КонецДобавления
	
	Возврат Колонки;
	
КонецФункции

// Возвращает колонки интеграционные потоки
// 
// Возвращаемое значение:
//  Структура - Где ключ имя колонки, значение описание типов колонки
//
Функция КолонкиИнтеграционныеПотоки() Экспорт
	
	Колонки = Новый Структура;
	
	// Добавление
	Колонки.Вставить("НаправлениеПотока"	, Новый ОписаниеТипов(
		"ПеречислениеСсылка.пбп_НаправленияИнтеграционныхПотоков"));
	// КонецДобавления
	
	Возврат Колонки;
	
КонецФункции

// Возвращает колонки настройки интеграции
// 
// Возвращаемое значение:
//  Структура - Где ключ имя колонки, значение описание типов колонки
//
Функция КолонкиНастройкиИнтеграции() Экспорт
	
	Колонки = Новый Структура;
	
	// Добавление
	Колонки.Вставить("ИнтегрируемаяСистема"	, Новый ОписаниеТипов("СправочникСсылка.пбп_ИнтегрируемыеСистемы"));
	Колонки.Вставить("ТипИнтеграции"		, Новый ОписаниеТипов("СправочникСсылка.пбп_ТипыИнтеграций"));
	Колонки.Вставить("СтрокаПодключения"	, пбп_ОбщегоНазначенияСервер.ОписаниеТипаСтрока(200));
	Колонки.Вставить("ТипАвторизации"		, Новый ОписаниеТипов("ПеречислениеСсылка.пбп_ТипыАвторизации"));
	Колонки.Вставить("ИмяОбъекта"			, пбп_ОбщегоНазначенияСервер.ОписаниеТипаСтрока(100));
	// КонецДобавления
	
	Возврат Колонки;
	
КонецФункции

// Возвращает колонки тип соответствия объектов ИБ
// 
// Возвращаемое значение:
//  Структура - Где ключ имя колонки, значение описание типов колонки
//
Функция КолонкиТипСоответствияОбъектовИБ() Экспорт
	
	Колонки = Новый Структура;
	
	// Добавление
	
	// КонецДобавления
	
	Возврат Колонки;
	
КонецФункции

#КонецОбласти

#Область ИсключаемыеПоляДляРасчетаХеша

// Возвращает исключаемые поля для расчета хеша элемент
// 
// Возвращаемое значение:
//  Массив - Исключаемые поля
//
Функция ИсключаемыеПоляДляРасчетаХешаЭлемент() Экспорт
	
	Поля = Новый Структура;
	Поля.Вставить("ХешСумма");
	Поля.Вставить("УровеньИерархии");
	Поля.Вставить("ИдентификаторРодитель");
	
	Возврат Поля;
	
КонецФункции

// Возвращает исключаемые поля для расчета хеша группа
// 
// Возвращаемое значение:
//  Массив - Исключаемые поля
//
Функция ИсключаемыеПоляДляРасчетаХешаГруппа() Экспорт
	
	Поля = Новый Структура;
	Поля.Вставить("ХешСумма");
	Поля.Вставить("УровеньИерархии");
	Поля.Вставить("ИдентификаторРодитель");
	Поля.Вставить("Пароль");
	Поля.Вставить("СписокЗначений");
	
	Возврат Поля;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

Функция ОбщиеКолонки(Менеджер)
	
	массив = Новый Массив;
	массив.Добавить(ТипЗнч(Менеджер.ПустаяСсылка()));
	ОписаниеТиповЭлемента = Новый ОписаниеТипов(массив);
	
	Колонки = Новый Структура;
	
	ОписаниеСтрока = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(150));
	ОписаниеБулево = Новый ОписаниеТипов("Булево");
	
	Колонки.Вставить("ИдентификаторНастройки", ОписаниеСтрока);
	Колонки.Вставить("Наименование", ОписаниеСтрока);
	Колонки.Вставить("ЭтоГруппа", ОписаниеБулево);
	Колонки.Вставить("Родитель", ОписаниеТиповЭлемента);
	
	Колонки.Вставить("УровеньИерархии", Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(2,0)));
	Колонки.Вставить("ИдентификаторРодитель", ОписаниеСтрока);
	Колонки.Вставить("ХешСумма", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(32)));
	
	Колонки.Вставить("Служебный_ОбновитьЭлемент", ОписаниеБулево);
	Колонки.Вставить("Служебный_УстановитьФлагРучноеИзменение", ОписаниеБулево);
	Колонки.Вставить("Служебный_ПредопределенныйЭлемент", ОписаниеТиповЭлемента);
	Колонки.Вставить("Служебный_СоздатьЗаписьРегистра", ОписаниеБулево);
	Колонки.Вставить("Служебный_Иерархический", ОписаниеБулево);
	Колонки.Вставить("Служебный_ИерархияГруппИЭлементов", ОписаниеБулево);
	
	Возврат Колонки;
	
КонецФункции

Процедура СоздатьКолонкиТаблицыПредопределенныхЭлементов(СтруктураСКолонками, Таблица)
	
	Для Каждого КлючЗначение Из СтруктураСКолонками Цикл
		Если Таблица.Колонки.Найти(КлючЗначение.Ключ) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Таблица.Колонки.Добавить(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
