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

////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	пбп_МодификацияКонфигурацииПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьОтца(Команда)
	
	ПоказатьОтцаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсказатьКогдаОбед(Команда)
	
	ШаблонСообщения = НСтр("ru='Привет, текущее время %1'; en='Hello, the current time is %1'");
	ТекстСообщения = СтрШаблон(ШаблонСообщения,
		Формат(пбп_ОбщегоНазначенияВызовСервера.ТекущаяДатаПользователя(), "ДЛФ=DT"));
	
	пбп_ПереадресацияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьОтца(Команда)
	
	СкрытьОтцаНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СкрытьОтцаНаСервере()
	
	Если Не пбп_ПереадресацияКлиентСервер.ЗначениеСвойстваЭлементаФормы(Элементы, "_ДемоBotFather", "Видимость") Тогда
		пбп_Переадресация.СообщитьПользователю(НСтр("ru='Он и так не с нами.'; en='He`s not with us anyway.'"));
	Иначе
		пбп_ПереадресацияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "_ДемоBotFather", "Видимость", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьОтцаНаСервере()
	
	Если пбп_ПереадресацияКлиентСервер.ЗначениеСвойстваЭлементаФормы(Элементы, "_ДемоBotFather", "Видимость") Тогда
		пбп_Переадресация.СообщитьПользователю(НСтр("ru='Присмотрись получше.'; en='Take a closer look.'"));
	Иначе
		пбп_ПереадресацияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "_ДемоBotFather", "Видимость", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти