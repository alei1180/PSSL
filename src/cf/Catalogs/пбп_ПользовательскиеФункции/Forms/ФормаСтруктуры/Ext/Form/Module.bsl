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

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АдресЗначения", АдресЗначения) Тогда
		Значение = ПолучитьИзВременногоХранилища(АдресЗначения);
		Если Значение <> Неопределено Тогда
			Для Каждого Пара Из Значение Цикл
				нСтрока = Структура.Добавить();
				ЗаполнитьЗначенияСвойств(нСтрока, Пара);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если СохранитьРезультат Тогда
		Адрес = АдресСтруктурыВХранилище();
		ОповеститьОВыборе(Новый Структура("Адрес", Адрес));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСтруктура

&НаКлиенте
Процедура СтруктураКлючПриИзменении(Элемент)
	ТекДанные = Элементы.Структура.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекДанные.Ключ) Тогда
		Результат = СтрЗаменить(ТекДанные.Ключ, " ", "");
		Пока пбп_ПереадресацияКлиентСервер.ЭтоЧисло(Сред(Результат, 1, 1)) Цикл
			Результат = Прав(Результат, СтрДлина(Результат) - 1);
		КонецЦикла;
		пбп_ОбщегоНазначенияКлиентСервер.УдалитьНедопустимыеСимволы(Результат);
		ТекДанные.Ключ = Результат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьРезультат(Команда)
	СохранитьРезультат = Истина;
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция АдресСтруктурыВХранилище()
	
	Результат = Новый Структура;
	Для Каждого Пара Из Структура Цикл
		Результат.Вставить(Пара.Ключ, Пара.Значение);
	КонецЦикла;
	УИД = ?(ПустаяСтрока(АдресЗначения), Новый УникальныйИдентификатор, АдресЗначения);
	Адрес = ПоместитьВоВременноеХранилище(Результат, УИД);
	
	Возврат Адрес;
	
КонецФункции

#КонецОбласти
