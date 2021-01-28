# language: ru

Функциональность: Настройка конфигурации прекоммита

Как разработчик
Я хочу иметь возможность изменять настройки precommit4onec
Чтобы автоматически выполнять обработку исходников перед фиксацией изменений в репозитории

Контекст:
	Допустим Я очищаю параметры команды "oscript" в контексте 
		И я очищаю параметры команды "git" в контексте
		И Я устанавливаю кодировку вывода "utf-8" команды "git"
		И я включаю отладку лога с именем "oscript.app.precommit4onec"
		И я создаю временный каталог и запоминаю его как "КаталогРепозиториев"
		И я переключаюсь во временный каталог "КаталогРепозиториев"
		И я создаю новый репозиторий без инициализации "rep1" в каталоге "КаталогРепозиториев" и запоминаю его как "РабочийКаталог"
		# И я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os install rep1"
		И я установил рабочий каталог как текущий каталог

Сценарий: Настройки глобальных сценариев
    Когда Я создаю файл "answers.txt" в кодировке "cp866" с текстом 
    """
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
y
local
n
    """
	Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os configure -rep-path .\ -config < answers.txt"
	Тогда Код возврата команды "oscript" равен 0
    И Я сообщаю вывод команды "oscript"
    И Файл "v8config.json" содержит
    """
        "ИспользоватьСценарииРепозитория": true,
        "КаталогЛокальныхСценариев": "local",
        "ГлобальныеСценарии": [
            "ДобавлениеПробеловПередКлючевымиСловами.os",
            "ЗапретИспользованияПерейти.os",
            "ИсправлениеНеКаноническогоНаписания.os",
            "КорректировкаXMLФорм.os",
            "ОбработкаЮнитТестов.os",
            "ОтключениеПолнотекстовогоПоиска.os",
            "ПроверкаДублейПроцедурИФункций.os",
            "ПроверкаКорректностиОбластей.os",
            "РазборОбычныхФормНаИсходники.os",
            "РазборОтчетовОбработокРасширений.os",
            "СинхронизацияОбъектовМетаданныхИФайлов.os",
            "СортировкаДереваМетаданных.os",
            "УдалениеДублейМетаданных.os",
            "УдалениеЛишнихКонцевыхПробелов.os",
            "УдалениеЛишнихПустыхСтрок.os"
        ],
    """

Сценарий: Настройки подпроекта
    Когда Я создаю файл "answers.txt" в кодировке "cp866" с текстом 
    """
n
n
n
y
tests
n
n
n
n
    """
    И Я создаю каталог "tests" в рабочем каталоге
	Когда Я выполняю команду "oscript" с параметрами "<КаталогПроекта>/src/main.os configure -rep-path .\ -config < answers.txt"
    И Я сообщаю вывод команды "oscript"
	Тогда Код возврата команды "oscript" равен 0
    И Файл "v8config.json" содержит "tests\\"

