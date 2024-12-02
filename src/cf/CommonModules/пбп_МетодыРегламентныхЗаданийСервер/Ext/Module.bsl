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

//Длительность хранения ошибок интеграции на месяц дольше, чем успешных записей
Процедура ОчисткаИсторииИнтеграции() Экспорт
	
	пбп_Переадресация.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.пбп_ОчисткаИсторииИнтеграции);
	Справочники.пбп_ИсторияИнтеграции.ОчиститьИсториюИнтеграции();
	
КонецПроцедуры

// Выполнение пользовательских функций файловых обменов
//
// Параметры:
//  НастройкаИнтеграции		 - СправочникСсылка.пбп_НастройкиИнтеграции - настройка интеграции интеграционного
//   потока, для которого выполняется регламентное задание
//  ПользовательскаяФункция	 - СправочникСсылка.пбп_ПользовательскиеФункции - выполняемая пользовательская функция
//
Процедура ВыполнениеПользовательскихФункцийФайловыхОбменов(НастройкаИнтеграции, ПользовательскаяФункция) Экспорт
	
	пбп_Переадресация.ПриНачалеВыполненияРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.пбп_ВыполнениеПользовательскихФункцийФайловыхОбменов);
	
	ПараметрыФункции = Новый Структура;
	ПараметрыФункции.Вставить("НастройкаИнтеграции", НастройкаИнтеграции);
	
	РезультатОбработки = пбп_ОбщегоНазначенияСервер.ВыполнитьПользовательскуюФункциюСПараметрами(
		ПользовательскаяФункция, ПараметрыФункции);
	
КонецПроцедуры

// Заполнение предопределенных элементов, с выводом серверного оповещения при возникновении конфликтов.
//
Процедура ЗаполнениеПредопределенныхЭлементов() Экспорт
	
	пбп_Переадресация.ПриНачалеВыполненияРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.пбп_ЗаполнениеПредопределенныхЭлементов);
		
	пбп_ПредопределенныеЗначения.ЗаполнениеПредопределенныхЭлементов(Истина);
	
КонецПроцедуры

#КонецОбласти
