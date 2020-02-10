Перем ЛокальныеНастройки;
Перем ГлобальныеНастройки;
Перем ИспользуютсяЛокальныеНастройки;

Перем Проекты;

Перем КаталогЛокальныхНастроек;
Перем НастройкиИнициализированы;

///////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
///////////////////////////////////////////////////////////////////

Функция Настройки() Экспорт
	
	Если НЕ НастройкиИнициализированы Тогда
		
		ВызватьИсключение "Настройки не загружены";
		
	КонецЕсли;

	Если ИспользуютсяЛокальныеНастройки() Тогда

		Возврат ЛокальныеНастройки;

	Иначе

		Возврат ГлобальныеНастройки;

	КонецЕсли;

КонецФункции

Функция НастройкиРепозитория(КаталогРепозитория, ВернутьГлобальныеЕслиНетЛокальных = Истина) Экспорт
	
	Если ВернутьГлобальныеЕслиНетЛокальных Тогда
		
		ГлобальныеНастройки();
		
	КонецЕсли;
	
	Лог = МенеджерПриложения.ПолучитьЛог();
	
	ЛокальныеНастройки = Новый НастройкиРепозитория(КаталогРепозитория);
	
	ИспользуютсяЛокальныеНастройки = ЕстьНастройкиPrecommt4onec(ЛокальныеНастройки) ИЛИ НЕ ВернутьГлобальныеЕслиНетЛокальных;
	
	Если ИспользуютсяЛокальныеНастройки Тогда
		
		КаталогЛокальныхНастроек = КаталогРепозитория;
		ВозвращаемаяНастройка = ЛокальныеНастройки;


	Иначе
		
		КаталогЛокальныхНастроек = Неопределено;
		ВозвращаемаяНастройка = ГлобальныеНастройки;
		
		
		Если НЕ ЕстьНастройкиPrecommt4onec(ГлобальныеНастройки) Тогда
			
			Лог.Предупреждение("Файл глобальных настроек '%1' не содержит настройки прекоммита", МенеджерПриложения.ПутьКРодительскомуКаталогу());

		КонецЕсли;

	КонецЕсли;

	Проекты = Неопределено;
	НастройкиИнициализированы = Истина;

	Возврат ВозвращаемаяНастройка;
	
КонецФункции

Функция ГлобальныеНастройки() Экспорт

	Если ГлобальныеНастройки = Неопределено Тогда
	
		ГлобальныеНастройки = Новый НастройкиРепозитория(МенеджерПриложения.ПутьКРодительскомуКаталогу());
		Проекты = Неопределено;

	КонецЕсли;
	
	НастройкиИнициализированы = Истина;
	
	Возврат ГлобальныеНастройки;
	
КонецФункции

Функция ЗначениеНастройки(КлючНастройки, Подпроект = Неопределено, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Значение = ЗначениеНастроекПоКлючу(Настройки(), КлючНастройки(Подпроект, КлючНастройки));
	
	Возврат ?(Значение = Неопределено, ЗначениеПоУмолчанию, Значение);
		
КонецФункции

Функция ИменаЗагружаемыхСценариев(Подпроект = "") Экспорт

	ИменаИсключаемыхСценариев = ЗначениеНастройки("ОтключенныеСценарии", Подпроект);
	
	ГлобальныеСценарии = ЗначениеНастройки("ГлобальныеСценарии", Подпроект);
	
	Если ГлобальныеСценарии = Неопределено Тогда
		
		ГлобальныеСценарии = ПолучитьЗначениеНастройки(ГлобальныеНастройки(), "ГлобальныеСценарии");

	КонецЕсли;

	ИменаЗагружаемыхСценариев = Новый Массив;
	
	Если ИменаИсключаемыхСценариев = Неопределено Тогда
		
		ИменаИсключаемыхСценариев = Новый Массив();
		
	КонецЕсли;
	
	Для Каждого ИмяСценария Из ГлобальныеСценарии Цикл
		
		Если ИменаИсключаемыхСценариев.Найти(ИмяСценария) = Неопределено Тогда
			
			ИменаЗагружаемыхСценариев.Добавить(ИмяСценария);

		КонецЕсли;
		
	КонецЦикла;

	Возврат ИменаЗагружаемыхСценариев;
	
КонецФункции

Функция ПолучитьСписокИсполняемыхСценариев(Знач ГлобальныеСценарии, Знач ОтключенныеСценарии) Экспорт

	ИменаЗагружаемыхСценариев = Новый Массив;
	
	Если ОтключенныеСценарии = Неопределено Тогда
		
		ОтключенныеСценарии = Новый Массив();
		
	КонецЕсли;
	
	Для Каждого ИмяСценария Из ГлобальныеСценарии Цикл
		
		Если ОтключенныеСценарии.Найти(ИмяСценария) = Неопределено Тогда
			
			ИменаЗагружаемыхСценариев.Добавить(ИмяСценария);

		КонецЕсли;
		
	КонецЦикла;

	Возврат ИменаЗагружаемыхСценариев;

КонецФункции

Функция КлючНастройкиPrecommit() Экспорт
	
	Возврат "Precommt4onecСценарии";
	
КонецФункции

Функция КлючПроекты() Экспорт
	
	Возврат "Проекты";
	
КонецФункции

Функция ИспользуютсяЛокальныеНастройки() Экспорт
	
	Возврат ИспользуютсяЛокальныеНастройки = Истина;

КонецФункции

Функция ПроектыКонфигурации() Экспорт
	
	Если Проекты <> Неопределено Тогда
		
		Возврат Проекты;
		
	КонецЕсли;

	Проекты = Новый Массив;

	БлокПроекты = ЗначениеНастройки(КлючПроекты());
	
	Если ЗначениеЗаполнено(БлокПроекты) Тогда
		
		Для Каждого Элемент Из БлокПроекты Цикл
			
			Проекты.Добавить(Элемент.Ключ);
						
		КонецЦикла;
	
	КонецЕсли;
	
	Возврат Проекты;
	
КонецФункции

Функция НастройкиПроекта(Подпроект = "") Экспорт
	
	Значение = ПолучитьНастройкиПроекта(Настройки(), Подпроект);

	Возврат Значение;

КонецФункции

Функция НастройкаДляФайла(Знач ОтносительноеИмяФайла) Экспорт
	
	Возврат НастройкиПроекта(ИмяПроектаДляФайла(ОтносительноеИмяФайла));

КонецФункции

Функция ИмяПроектаДляФайла(Знач ОтносительноеИмяФайла) Экспорт

	Если СтрНачинаетсяС(ОтносительноеИмяФайла, "/") ИЛИ СтрНачинаетсяС(ОтносительноеИмяФайла, "\") Тогда
		
		ОтносительноеИмяФайла = Сред(ОтносительноеИмяФайла, 2);
		
	КонецЕсли;
	
	ОтносительноеИмяФайла = СтрЗаменить(НРег(ОтносительноеИмяФайла), "\", "/");

	Для Каждого ИмяПроекта Из ПроектыКонфигурации() Цикл
		
		НормализованноеИмяФайла = Лев(ОтносительноеИмяФайла, СтрДлина(ИмяПроекта));

		НормализованноеИмяПроекта = СтрЗаменить(НРег(ИмяПроекта), "\", "/");
		
		Если НормализованноеИмяПроекта = НормализованноеИмяФайла Тогда
			
			Возврат ИмяПроекта;

		КонецЕсли;
		
	КонецЦикла;
	
	Возврат "";
	
КонецФункции

Функция ЭтоНовый() Экспорт
	
	Возврат Настройки().ЭтоНовый();
	
КонецФункции

///////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ФУНКЦИОНАЛ
///////////////////////////////////////////////////////////////////

Функция ПолучитьИменаСценариевКаталога(КаталогСценариев) Экспорт
	
	НайденныеСценарии = Новый Массив;
	ФайлыСценариев = НайтиФайлы(КаталогСценариев, "*.os");
	Для Каждого ФайлСценария Из ФайлыСценариев Цикл
		
		Если СтрСравнить(ФайлСценария.ИмяБезРасширения, "ШаблонСценария") = 0 Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		НайденныеСценарии.Добавить(ФайлСценария.Имя);
		
	КонецЦикла;
	
	Возврат НайденныеСценарии;
	
КонецФункции

Функция КлючНастройки(Проект = Неопределено, КлючНастройки = Неопределено)
	
	Ключ = Новый Массив();

	Если ЗначениеЗаполнено(Проект) И ЕстьПроект(Проект) Тогда
		
		Ключ.Добавить(КлючПроекты());
		Ключ.Добавить(Проект);
		
	КонецЕсли;

	Если ЗначениеЗаполнено(КлючНастройки) Тогда
		
		Ключ.Добавить(КлючНастройки);
		
	КонецЕсли;

	Возврат Ключ;
		
КонецФункции

Функция ЕстьПроект(Проект)
	
	Возврат ПроектыКонфигурации().Найти(Проект) <> Неопределено;
	
КонецФункции

Функция ПолучитьНастройкиПроекта(Настройка, Подпроект) Экспорт
	
	Значение = ЗначениеНастроекПоКлючу(Настройка, КлючНастройки(Подпроект));
	
	Если Значение = Неопределено Тогда
		
		Значение = ЗначениеНастроекПоКлючу(Настройка, "");
		
	КонецЕсли;

	Возврат Значение;

КонецФункции

Функция ЗначениеНастроекПоКлючу(Настройка, КлючНастройки)
	
	Значение = Настройка.НастройкиПриложения(КлючНастройкиPrecommit());
	
	Если НЕ ЗначениеЗаполнено(КлючНастройки) Тогда
		
		Возврат Значение;
		
	ИначеЕсли ТипЗнч(КлючНастройки) = Тип("Строка") Тогда
		
		Ключи = СтрРазделить(КлючНастройки, "\");
		
	Иначе
		
		Ключи = КлючНастройки;
		
	КонецЕсли;

	Для каждого Ключ Из Ключи Цикл
		
		Значение = Значение.Получить(Ключ);
		
		Если Значение = Неопределено Тогда
			
			Прервать;
			
		КонецЕсли;

	КонецЦикла;
	
	Возврат Значение;
	
КонецФункции

Функция ЗначениеПоКлючу(Коллекция, КлючЗначения) Экспорт
	
	Значение = Коллекция;
	
	Если НЕ ЗначениеЗаполнено(КлючЗначения) Тогда
		
		Возврат Значение;
		
	ИначеЕсли ТипЗнч(КлючЗначения) = Тип("Строка") Тогда
		
		Ключи = СтрРазделить(КлючЗначения, "\");
		
	Иначе
		
		Ключи = КлючЗначения;
		
	КонецЕсли;

	Для каждого Ключ Из Ключи Цикл
		
		Значение = Значение.Получить(Ключ);
		
		Если Значение = Неопределено Тогда
			
			Прервать;
			
		КонецЕсли;

	КонецЦикла;
	
	Возврат Значение;

КонецФункции

Функция ЕстьНастройкиPrecommt4onec(Настройка)
	
	Возврат НЕ Настройка.ЭтоНовый() И ЗначениеНастроекПоКлючу(Настройка, "").Количество();

КонецФункции

Функция ПолучитьЗначениеНастройки(Настройка, КлючНастройки, Подпроект = Неопределено)
	
	Значение = ЗначениеНастроекПоКлючу(Настройка, КлючНастройки(Подпроект, КлючНастройки));

	Возврат Значение;
		
КонецФункции

НастройкиИнициализированы = Ложь;