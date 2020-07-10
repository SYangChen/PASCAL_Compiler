# Compiler Lab2 : Pascal Scanner
LEX、YACC製作出簡易的Pascal Compiler，並給予適當的error recovery。
## Lex版本
flex 2.6.4
## Yacc版本
bison 3.0.4
## 執行方式
* make clean
* make ( all )
* ./a.out < testfile.pas
## 如何處理這份規格書上的問題
### Get Token
與上次lex作業大同小異，且將reserved word一一分開，並return 各自token name給yacc。
### Match Grammer
透過基本的grammer並做自己所錯誤修正的grammer整理為以下規則。
``` grammer
<prog> ::= PROGRAM <prog-name> ; VAR <dec-list> ; BEGIN <stmt-list> ; END.
<prog-name> ::= id
<dec-list> ::= <dec> | <dec-list> ; <dec>
<dec> ::= <id-list> : <type>
<type> ::= <standtype> | <arraytype>
<standtype> ::= INTEGER | REALTYPE | STRINGTYPE
<arraytype> ::= ARRAY [int .. int] OF <standtype>
<id-list> ::= id | <id-list> , id
<arg-list> ::= <argument> | <arg-list> , <argument>
<argument> ::= <varid> | STRINGVALUE
<stmt-list> ::= <stmt> | <stmt-list> ; <stmt>
<stmt> ::= <assign> | <read> | <write> | <for> | <ifstmt> | <writeln>
<assign> ::= <varid> := <simpexp>
<ifstmt> ::= IF ( <exp> ) THEN <body>
<exp> ::= <simpexp> | <exp> <relop> <simpexp>
<relop> ::= > | < | >= | <= | <> | =
<simpexp> ::= <term> | <simpexp> + <term>| <simpexp> - <term>
<term> ::= <factor> { * <factor> | DIV <factor> | mod <factor> }
<factor> ::= <varid> | int | real | ( <simpexp> )
<read> ::= READ ( <arg-list> )
<write> ::= WRITE ( <arg-list> )
<writeln> ::= WRITELN | WRITELN ( <arg-list> )
<for> ::= FOR <index-exp> DO <body>
<index-exp> ::= <varid> := <simpexp> TO <exp>
<varid> ::= id | id [ <simpexp> ]
<body> ::= <stmt> | BEGIN <stmt-list> ; END
```
### Error Recovery

#### 1. 變數(或函數)未定義就使用，或是賦值型態與宣告型態不同(宣告 integer，賦值 string)
透過symbol table(動態增加陣列結構)來記錄所有已定義過的參數，在var-begin間的定義空間記錄其名稱與型態，且確保此ID名字尚未被使用過，並在後面statment使用時為其進行檢查，並確保此ID存在。
**error message：**
```
duplicate identifier    ( 重複定義ID )
Identifier not found    ( 使用未定義ID )
```
當通過symbol table確認此ID存在後，為判斷其賦值型態是否正確，在assign(:=)前我會先記錄目前的型態，而後面出現的型態要能完全能夠賦值給左邊的變數。正確的型態賦值為int := int、double := double、double := int、string := string，只要有其他類型一律都是錯誤。(int+double視為double)
**assign右邊的型態單一**
**error message：**
```
Incompatible types: got "Real" expected "Integer"          ( int := double )
Incompatible types: got "String" expected "Integer/Double" ( int/double := string )
Incompatible types: got "Integer/Double" expected "String" ( string := int/double )
```
#### 2. 結構有缺失，如遺漏左括號、then 前面沒有 if 等等
在可能會缺失的token上，以特殊方式提出來檢查，而其中所提出的token除了自己正確的token以外，還可以是空白或是其他不同字元，然而因為compiler在左括號出現前，是不會知道有右括號，同理在if出現前是不會知道後面有then，因此當出現這兩個問題時，我的compiler是模擬真實情況所出現的，但由於我們所時做的compiler要error recovery就算錯誤也要繼續往下完成，指放棄那一行的處理，因此左括號的缺失我原本是不想特別處理，因為它並不是特例，但為了能順利往下執行，而非像真實的compiler一樣直接aborted整個程式，我出現左括號缺失的錯誤暫時不模擬實際的compiler之結果。
**error message:**
```
Syntax error, ";" expected but "then" found ( 缺失if )
Syntax error, "(" expected but "next_token" found  ( 缺失"(" )
```
#### 3. 缺少必要的符號(分號、句號等等)或使用錯誤的符號
缺失符號或使用錯誤的符號，一樣以一個小的grammer切割出來，並允許除了其token以外，也允許空白(缺失)或是其他各種不同的符號(typo)。
另外，若缺失或使用錯誤的符號是在ASSIGN(:=)的部分，我會以這個statement找到分號做處理，並給予額外的錯誤(illegal expression)。
**error message:**
```
Syntax error, ";" expected but "next_token" found ( 缺失if )
Syntax error, "." expected but "next_token" found  ( 缺失".")
Illegal expression
```

#### 4. 不同類別的變數相加，如：int + string
記錄所有assign右邊有出現過的type，並給予適當的錯誤資訊，其中因為我將integer+real視為real，已在第1.的錯誤中處理完畢，因此僅剩下當右邊有string type運算的問題
**assign右邊有string型態與其他型態相加減**
**error message：**
```
Operator is not overloaded: "Double" + "String" ( anyType := double+string )
Incompatible types: got "Integer" expected "String" ( anyType := int+string )
Operation "-/*///mod" not supported for types "Integer/Double/String" and "Integer/Double/String"
( 只要有除了+以外的operator與string做運算，types error取決於前兩個運算型態，且其中一個必定是第一個被運算的string )
```
## 寫這個作業所遇到的問題：
雖然已經算是熟悉Lex以及其運用regular expression的語法，但對於yacc仍然是第一次接觸難免花時間理解，即便生疏，但透過很多次的try and error，去嘗試並熟悉規則的撰寫。

我認為自己想了很多有可能出現的測試資料，讓我在撰寫的過程中想了很多使用者可能會寫出來的結果，也盡量將所有可能出現的結果避免掉，所以在除了一般的要求外，多做了很多不同的測試，也將我能想到的所有錯誤避免掉，花了較多的時間。

遇到無法理解的錯誤資訊，例如突然出現的無窮迴圈、或是在控制不到的地方所出現的一些程式上的error，只能盡量避免並猜測出現之原因，而非完全理解其生成原因，也可能造成無法預知之成果，但透過不斷嘗試也能找到不錯的解法。

## 測試檔執行出來的結果：
### %./a.out < correct.pas
![](https://i.imgur.com/qbf6siZ.png)
### %./a.out < error1.pas
![](https://i.imgur.com/x2jCaAb.png)
### %./a.out < error2.pas
![](https://i.imgur.com/vqEPhLK.png)
### %./a.out < error3.pas
![](https://i.imgur.com/yMfjsVk.png)
### %./a.out < error4.pas
![](https://i.imgur.com/ldLVuzH.png)


## 可以加分的項目：
#### 顏色
```
正確的行數以淺灰色顯示
錯誤行數以白色顯示，其中error部分以紅色提點
```
#### string除了+以外會出現的錯誤，且會跟著使用者的輸入順序而改變
```
Operation "-/*///mod" not supported for types "Integer/Double/String" and "Integer/Double/String"
( 只要有除了+以外的operator與string做運算，types error取決於前兩個運算型態，且其中一個必定是第一個被運算的string )
```
#### array中括號中的運算必須為整數
```
如同賦值給integer型態以及當中有錯誤型態的運算(string、double)
```