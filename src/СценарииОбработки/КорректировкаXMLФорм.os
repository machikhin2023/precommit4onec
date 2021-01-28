///////////////////////////////////////////////////////////////////////////////
// 
// Служебный модуль с реализацией сценариев обработки файлов КорректировкаXMLФорм
//
///////////////////////////////////////////////////////////////////////////////

// ИмяСценария
//	Возвращает имя сценария обработки файлов
//
// Возвращаемое значение:
//   Строка   - Имя текущего сценария обработки файлов
//
Функция ИмяСценария() Экспорт
	
	Возврат "КорректировкаXMLФорм";

КонецФункции // ИмяСценария()

// ОбработатьФайл
//	Выполняет обработку файла
//
// Параметры:
//  АнализируемыйФайл		- Файл - Файл из журнала git для анализа
//  КаталогИсходныхФайлов  	- Строка - Каталог расположения исходных файлов относительно каталог репозитория
//  ДополнительныеПараметры - Структура - Набор дополнительных параметров, которые можно использовать 
//  	* Лог  					- Объект - Текущий лог
//  	* ИзмененныеКаталоги	- Массив - Каталоги, которые необходимо добавить в индекс
//		* КаталогРепозитория	- Строка - Адрес каталога репозитория
//		* ФайлыДляПостОбработки	- Массив - Файлы, изменившиеся / образовавшиеся в результате работы сценария
//											и которые необходимо дообработать
//
// Возвращаемое значение:
//   Булево   - Признак выполненной обработки файла
//
Функция ОбработатьФайл(АнализируемыйФайл, КаталогИсходныхФайлов, ДополнительныеПараметры) Экспорт
	
	Лог = ДополнительныеПараметры.Лог;
	НастройкиСценария = ДополнительныеПараметры.Настройки.Получить(ИмяСценария());
	Если НЕ АнализируемыйФайл.Существует() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ФорматEDT = ТипыФайлов.ЭтоФайлОписанияФормыEDT(АнализируемыйФайл);
	Если ТипыФайлов.ЭтоФайлОписанияФормы(АнализируемыйФайл) ИЛИ ФорматEDT Тогда
	
		Лог.Информация("Обработка файла '%1' по сценарию '%2'", АнализируемыйФайл.ПолноеИмя, ИмяСценария());
		
		Если ОбновитьИндексыЭлементовВФорме(АнализируемыйФайл.ПолноеИмя, ФорматEDT) Тогда
			ДополнительныеПараметры.ИзмененныеКаталоги.Добавить(АнализируемыйФайл.ПолноеИмя);
		КонецЕсли;

		Возврат Истина;

	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции // ОбработатьФайл()

Функция ОбновитьИндексыЭлементовВФорме(Знач ИмяФайла, EDT = Ложь)

	СодержимоеФайла = ФайловыеОперации.ПрочитатьТекстФайла(ИмяФайла);

	ПаттернID = ?(EDT, "<id>([0-9-]+)<\/id>", "id=\""([0-9-]+)\""\/*>");

	Регексп = Новый РегулярноеВыражение(ПаттернID);
	Регексп.ИгнорироватьРегистр = ИСТИНА;
	Регексп.Многострочный = ИСТИНА;
	ГруппыИндексов = Регексп.НайтиСовпадения(СодержимоеФайла);
	Если ГруппыИндексов.Количество() = 0 Тогда

		Возврат ЛОЖЬ;	

	КонецЕсли;

	ТЧ = Новый ТаблицаЗначений;
	ТЧ.Колонки.Добавить("Значение");
	ТЧ.Колонки.Добавить("Количество");

	Для Каждого ГруппаИндексов Из ГруппыИндексов Цикл

		Значение = Число(ГруппаИндексов.Группы[1].Значение);

		СтрокаТЧ = ТЧ.Найти(Значение, "Значение");
		Если СтрокаТЧ = Неопределено Тогда 
			СтрокаТЧ = ТЧ.Добавить();
			СтрокаТЧ.Значение = Значение;
			СтрокаТЧ.Количество = 1; 
		Иначе
			СтрокаТЧ.Количество = СтрокаТЧ.Количество + 1;
		КонецЕсли;
	КонецЦикла;

	ТЧ.Свернуть("Значение", "Количество");
	
	Если ТЧ.Количество() = ГруппыИндексов.Количество() Тогда
		Возврат Ложь; 
	КонецЕсли;

	ТЧ.Сортировать("Значение УБЫВ");
	ПоследнийНомер = ТЧ[0].Значение;
	ТЧ.Сортировать("Количество УБЫВ");
	Для каждого СтрокаТЧ Из ТЧ Цикл

		Если СтрокаТЧ.Количество = 1 Тогда
	
			Прервать;
			
		КонецЕсли;
			
		Пока СтрокаТЧ.Количество > 1 Цикл

			ИсходнаяСтрока = ?(EDT, "<id>" + СтрокаТЧ.Значение + "<", "id=""" + СтрокаТЧ.Значение + """");
			ПоследнийНомер = ПоследнийНомер + 1;
			СтрокаЗамены = ?(EDT, "<id>" + ПоследнийНомер + "<", "id=""" + ПоследнийНомер + """");
	
			Поз = СтрНайти(СодержимоеФайла, ИсходнаяСтрока);
				
			НоваяСтрока = Лев(СодержимоеФайла, Поз - 1) + СтрокаЗамены;
			СодержимоеФайла = НоваяСтрока + Сред(СодержимоеФайла, Поз + СтрДлина(ИсходнаяСтрока));
	
			СтрокаТЧ.Количество = СтрокаТЧ.Количество - 1;
			
		КонецЦикла;

	КонецЦикла;

	ФайловыеОперации.ЗаписатьТекстФайла(ИмяФайла, СодержимоеФайла);

	Возврат Истина;
	
КонецФункции