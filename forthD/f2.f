// Внимание: Табуляции в исходном тексте не читает
1 2 3 4 5 

S" stdlib.f" 1+ INCLUDED // Загрузить стандартную библиотеку

// поместить на вершину стека данных значение сетчика команд процессора RDTC
// Измерение скорости работы по mOleg технологии. См. SPF-Fork
: TIMER@ // ( --> ud )
         [ 137 B, 69 B, 252 B, 15 B, 49 B, 137 B,
           85 B, 248 B, 141 B, 109 B, 248 B, 135 B, 69 B, 0 B, ] ;
: (measure) // ( xt --> dt ) // измерить длительность исполнения слова, представленного своим xt
    TIMER@ >R >R EXECUTE TIMER@ R> R> DROP SWAP DROP - ;

// Проверим Windows
IF=W Lib" CRTDLL.DLL" CrtDll
IF=W Library@ CrtDll 1 CDECL-Call" strlen"  strlen
IF=W Library@ CrtDll 2 CDECL-Call" strcmp"  strcmp
IF=W Library@ CrtDll 1 CDECL-Call" strncmp" strncmp
IF=W Library@ CrtDll 2 CDECL-Call" fputc"   putc
IF=W Library@ CrtDll 1 CDECL-Call" _fputchar"   _fputchar
IF=W Library@ CrtDll 2 CDECL-Call" fputwc"   fputwc
IF=W Library@ CrtDll 2 CDECL-Call" fputs"   fputs
IF=W Library@ CrtDll 2 CDECL-Call" fputwc"   fputwc
IF=W Library@ CrtDll 1 CDECL-Call" fgetwc"   fgetwc
IF=W Library@ CrtDll 2 CDECL-Call" fopen"   fopen
IF=W Library@ CrtDll 1 CDECL-Call" fclose"  fclose
IF=W Library@ CrtDll 0 GADR-Call" _iob"  ms6_iob

// Проверим Linux
IF=L Lib" libc.so.6" libcSo
IF=L Library@ libcSo 1 CDECL-Call" strlen"  strlen
IF=L Library@ libcSo 3 CDECL-Call" printf"  printf
IF=L Library@ libcSo 2 CDECL-Call" putc"    putc
IF=L Library@ libcSo 2 CDECL-Call" fopen"   fopen
IF=L Library@ libcSo 2 CDECL-Call" fputs"   fputs
IF=L Library@ libcSo 1 CDECL-Call" fclose"  fclose

IF=W LibraryLoad CrtDll
IF=L LibraryLoad libcSo

// Переменные хранящие указатли на открытые файлы 
VAR v_STDOUT        // stdout
VAR v_STDIN         // stdin
VAR v_STDERR        // stderr

IF=L (STDOUT)     v_STDOUT ! // В Linux  stdout == С++ gcc
IF=W ms6_iob 32 + v_STDOUT ! // В Winows stdout получаем непосредственно из _iob[1];
IF=W ms6_iob      v_STDIN  ! // В Winows stdin получаем из _iob[0];

// Моделирую работу с консолью через функции библиотеки stdc
: EMIT v_STDOUT @ putc DROP ; // ( N -- ) Вывод символа на стандартный вывод

: F_EMIT // ( File N -- ) Вывести символ в файл
    SWAP putc DROP ;
: CR  // ( -- ) Перевод строки
IF=W 13 EMIT
     10 EMIT
    ;
: F_CR  // ( File -- ) Перевод строки
    >R
IF=W R@ 13 F_EMIT
     R@ 10 F_EMIT RDROP
    ;
: TYPE  // ( Astrz N -- ) Напечатать строку
    DUP B@ BEGIN DUP WHILE SWAP 1+ DUP B@ EMIT SWAP 1- REPEAT DROP DROP ;
: F_TYPE // ( File Astrz -- ) Напечатать строку в файл
    SWAP >R DUP B@ BEGIN DUP WHILE SWAP 1+ DUP B@ R@ SWAP F_EMIT SWAP 1- REPEAT
    DROP DROP RDROP ;


\ Проверка работы форт
: ПроверкаФорт // ( -- )
    S" -----------------------------------------" TYPE CR
    S" Test working forth ---> " TYPE 2 5 + .
    S" -----------------------------------------" TYPE CR
    ;
ПроверкаФорт
. . . . .

