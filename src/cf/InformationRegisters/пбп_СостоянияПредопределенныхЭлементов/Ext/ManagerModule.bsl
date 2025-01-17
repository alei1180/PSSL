﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Создает запись регистра с заданными параметрами.
//
// Параметры:
//  Объект		 - СправочникСсылка, ПланВидовХарактеристикСсылка	 - Ссылка на предопределенный элемент.
//  ЭтоГруппа	 - Булево - Признак того что элемент является группой.
//  КлючиХеша	 - Структура, Неопределено - Если ключи хеша не переданы, то они будут сформированы заново.
//
Процедура СоздатьЗаписьРегистра(Объект, ЭтоГруппа = Ложь, КлючиХеша = Неопределено) Экспорт
	
	Если КлючиХеша = Неопределено Тогда
		КлючиХеша = КлючиХешаОбъект(Объект, ЭтоГруппа);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КлючиХеша) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(КлючиХеша, Объект);
	
	Набор = РегистрыСведений.пбп_СостоянияПредопределенныхЭлементов.СоздатьНаборЗаписей();
	Набор.Отбор.Объект.Установить(Объект);
	
	Запись = Набор.Добавить();
	Запись.Объект = Объект;
	Запись.ХешСумма = пбп_Переадресация.КонтрольнаяСуммаСтрокой(КлючиХеша, ХешФункция.MD5);
	
	Набор.Записать();
	
КонецПроцедуры

// Обновляет хеш элемента в регистре, устанавливая при этом ручное изменение.
//  Если хеш не был изменен по ключевым реквизитам, обновления не произойдет.
//
// Параметры:
//  Объект		 - СправочникСсылка, ПланВидовХарактеристикСсылка - Ссылка на предопределенный элемент
//  ЭтоГруппа	 - Булево										  - Признак того что элемент является группой
//  Флаг		 - Булево										  - Признак ручного изменения элемента.
//
Процедура ОбновитьХешЭлемента(Объект, ЭтоГруппа = Ложь, Флаг = Ложь) Экспорт
	
	КлючиХеша = КлючиХешаОбъект(Объект, ЭтоГруппа);
	
	Если Не ЗначениеЗаполнено(КлючиХеша) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(КлючиХеша, Объект);
	НовыйХешЭлемента = пбп_Переадресация.КонтрольнаяСуммаСтрокой(КлючиХеша, ХешФункция.MD5);
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.Объект.Установить(Объект);
	Набор.Прочитать();
	
	Если Не ЗначениеЗаполнено(Набор) Тогда
		СообщитьОбОтсутствииЗаписи(Объект);
		Возврат;
	КонецЕсли;
	
	Запись = Набор[0];
	Если НовыйХешЭлемента = Запись.ХешСумма Тогда
		Возврат;
	КонецЕсли;
	
	Запись.ХешСумма = НовыйХешЭлемента;
	Запись.РучноеИзменение = Флаг;
	Набор.Записать();
	
КонецПроцедуры

// Обновляет флаг ручного изменения элемента
//
// Параметры:
//  Объект  - СправочникСсылка, ПланВидовХарактеристикСсылка - Ссылка на предопределенный элемент
//  Флаг    - Булево										 - Устанавливается если были изменены ключевые поля пользователем.
//
Процедура ОбновитьФлагРучногоИзменения(Объект, Флаг) Экспорт
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.Объект.Установить(Объект);
	Набор.Прочитать();
	
	Если Не ЗначениеЗаполнено(Набор) Тогда
		СообщитьОбОтсутствииЗаписи(Объект);
		Возврат;
	КонецЕсли;
	
	Набор[0].РучноеИзменение = Флаг;
	Набор.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СообщитьОбОтсутствииЗаписи(Элемент)
	
	ТекстСообщения = НСтр("ru = 'При обновлении не найдена запись состояния по объекту ''%1'' не найдена!';
		|en = 'No status record found during update for object ''%1'' not found!'");
	ТекстСообщения = пбп_ПереадресацияКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстСообщения,
		Элемент.Ссылка);
	пбп_Переадресация.СообщитьПользователю(ТекстСообщения, Элемент);
	
КонецПроцедуры

Функция КлючиХешаОбъект(Объект, ЭтоГруппа)
	
	МенеджерОбъекта = пбп_Переадресация.МенеджерОбъектаПоСсылке(Объект);
	КлючевыеПоля = пбп_ПредопределенныеЗначенияСлужебный.КолонкиПредопределенныхЭлементов(МенеджерОбъекта);
	Если Не ЗначениеЗаполнено(КлючевыеПоля) Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	мПоля = Новый Массив;
	Для Каждого КлючЗначение Из КлючевыеПоля Цикл
		мПоля.Добавить(КлючЗначение.Ключ);
	КонецЦикла;
	
	Если ЭтоГруппа Тогда
		мПоля = пбп_ПредопределенныеЗначенияСлужебный.ПолучитьПоляГруппы(МенеджерОбъекта, мПоля);
	КонецЕсли;
	
	Возврат пбп_ПредопределенныеЗначения.КлючиХешаПредопределенногоЭлемента(мПоля, ЭтоГруппа);
	
КонецФункции

#КонецОбласти

#КонецЕсли