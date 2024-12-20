﻿#language: ru

@tree

Функционал: подсистема предопределенных значений

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

Сценарий: проверка создания предопределенных элементов плана видов характеристик 
* Заполнение предопределенных из кода
	Дано Я открываю основную форму списка плана видов характеристик 'пбп_ПредопределенныеЗначения'
	Тогда открылось окно 'Предопределенные значения'
	И я нажимаю на кнопку с именем 'ФормаЗаполнитьПредопределенные'
* Проверка наличия предопределенного элемента
	И в таблице  "Список" я перехожу на один уровень вниз
	И в таблице "Список" я перехожу к строке:
		| 'Идентификатор настройки'          | 'Код'       | 'Наименование'                                | 'Пароль' |
		| 'КолДнейХраненияИсторииИнтеграции' | '000000004' | 'Количество дней хранения истории интеграции' | 'Нет'    |
	И в таблице "Список" я активизирую поле с именем "Наименование"
	И в таблице "Список" я выбираю текущую строку
	Тогда открылось окно 'Количество дней хранения истории интеграции (Предопределенные значения)'
* Дозаполнение предопределенного элемента
	И в поле с именем 'Значение' я ввожу текст '28'
	И я нажимаю на кнопку с именем 'ФормаЗаписатьИЗакрыть'
	И я жду закрытия окна 'Количество дней хранения истории интеграции (Предопределенные значения) *' в течение 20 секунд
	Тогда открылось окно 'Предопределенные значения'
	И Я закрываю окно 'Предопределенные значения'