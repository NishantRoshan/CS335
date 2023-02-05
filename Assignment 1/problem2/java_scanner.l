%{
   #include <bits/stdc++.h>
   using namespace std;
 
   map<string,vector<string> > mp;
   vector<vector<string> > vec;
  
%}


%option c++
%option noyywrap
%option yylineno




Identifier         {JavaLetter}{JavaLetterOrDigit}*


JavaLetterOrDigit  [A-Z]|[a-z]|"$"|"_"|[0-9]


JavaLetter         [A-Z]|[a-z]|"$"|"_"


Whitespace         "\n"|"\t"|"\f"|"\r"|" "


Comment            {MultilineComment}|{EndOfLineComment}


EndOfLineComment   "//".*
MultilineComment   [/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]


Keyword            "abstract"|"assert"|"boolean"|"break"|"byte"|"case"|"catch"|"char"|"class"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extends"|"final"|"finally"|"float"|"for"|"if"|"goto"|"implements"|"import"|"instanceof"|"int"|"interface"|"long"|"native"|"new"|"package"|"private"|"protected"|"public"|"return"|"short"|"static"|"strictfp"|"super"|"switch"|"synchronized"|"this"|"throw"|"throws"|"transient"|"try"|"void"|"volatile"|"while"


Operator           "="|">"|"<"|"!"|"~"|"?"|":"|"->"|"=="|">="|"<="|"!="|"&&"|"||"|"++"|"--"|"+"|"-"|"*"|"/"|"&"|"|"|"^"|"%"|"<<"|">>"|">>>"|"+="|"-="|"*="|"/="|"&="|"|="|"^="|"%="|"<<="|">>="|">>>="


Separator          "("|")"|"{"|"}"|"["|"]"|";"|","|"."|"..."|"@"|"::"


Literal            {IntegerLiteral}|{FloatingPointLiteral}|{BooleanLiteral}|{CharacterLiteral}|{StringLiteral}|{TextBlock}|{NullLiteral}


IntegerLiteral       {DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral}


DecimalIntegerLiteral    {DecimalNumeral}{IntegerTypeSuffix}?
HexIntegerLiteral        {HexNumeral}{IntegerTypeSuffix}?
OctalIntegerLiteral      {OctalNumeral}{IntegerTypeSuffix}?
BinaryIntegerLiteral     {BinaryNumeral}{IntegerTypeSuffix}?
IntegerTypeSuffix        l|L


DecimalNumeral           0|{NonZeroDigit}{Digits}?|{NonZeroDigit}{Underscores}{Digits}
NonZeroDigit             [1-9]
Digits                   {Digit}|{Digit}{DigitsAndUnderscores}?{Digit}
Digit                    0|{NonZeroDigit}
DigitsAndUnderscores     {DigitOrUnderscore}{DigitOrUnderscore}*
DigitOrUnderscore        {Digit}|_
Underscores              _[_]*


HexNumeral               0x{HexDigits}|0X{HexDigits}
HexDigits                {HexDigit}|{HexDigit}{HexDigitsAndUnderscores}?{HexDigit}
HexDigit                 [0-9]|[a-f]|[A-F]
HexDigitsAndUnderscores  {HexDigitOrUnderscore}{HexDigitOrUnderscore}*
HexDigitOrUnderscore     {HexDigit}|_


OctalNumeral             0{OctalDigits}|0{Underscores}{OctalDigits}
OctalDigits              {OctalDigit}|{OctalDigit}{OctalDigitsAndUnderscores}?{OctalDigit}
OctalDigit               [0-7]
OctalDigitsAndUnderscores {OctalDigitOrUnderscore}{OctalDigitOrUnderscore}*
OctalDigitOrUnderscore   {OctalDigit}|_


BinaryNumeral            0b{BinaryDigits}|0B{BinaryDigits}
BinaryDigits             {BinaryDigit}|{BinaryDigit}{BinaryDigitsAndUnderscores}?{BinaryDigit}
BinaryDigit              0|1
BinaryDigitsAndUnderscores {BinaryDigitOrUnderscore}{BinaryDigitOrUnderscore}*
BinaryDigitOrUnderscore  {BinaryDigit}|_


FloatingPointLiteral     {DecimalFloatingPointLiteral}|{HexadecimalFloatingPointLiteral}
DecimalFloatingPointLiteral   {Digits}"."{Digits}?{ExponentPart}?{FloatTypeSuffix}?|"."{Digits}{ExponentPart}?{FloatTypeSuffix}?|{Digits}{ExponentPart}{FloatTypeSuffix}?|{Digits}{ExponentPart}?{FloatTypeSuffix}
ExponentPart             {ExponentIndicator}{SignedInteger}
ExponentIndicator        e|E
SignedInteger            {Sign}?{Digits}
Sign                     "+"|"-"
FloatTypeSuffix          f|F|d|D


HexadecimalFloatingPointLiteral    {HexSignificand}{BinaryExponent}{FloatTypeSuffix}?
HexSignificand           {HexNumeral}[.]?|0x{HexDigits}?[.]{HexDigits}|0X{HexDigits}?[.]{HexDigits}
BinaryExponent           {BinaryExponentIndicator}{SignedInteger}
BinaryExponentIndicator  p|P


BooleanLiteral           true|false


CharacterLiteral         \'[^\r\n\']\'


StringLiteral            \"[^\r\n\"]*\"


TextBlock                \"\"\"[ \t\f]*{LineTerminator}{Everything}*\"\"\"
LineTerminator           \n|\r|"\r\n"
Everything               ["]{0,2}[^"]+


NullLiteral              null


%%
{Keyword}                                        {if(mp.find(YYText())==mp.end()){
                                                        mp[YYText()] = {YYText(),"Keyword","1"};
                                                        vec.push_back({YYText(),"Keyword","1"});
                                                 }
                                                  else{
                                                     auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                     vec[it-vec.begin()] = {YYText(),"Keyword",to_string(stoi(mp[YYText()][2])+1)};
                                                     mp[YYText()] = {YYText(),"Keyword",to_string(stoi(mp[YYText()][2])+1)};                    
                                                  }
                                                }


{Operator}                                       {if(mp.find(YYText())==mp.end()){
                                                       mp[YYText()] = {YYText(),"Operator","1"};
                                                       vec.push_back({YYText(),"Operator","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                      vec[it-vec.begin()] = {YYText(),"Operator",to_string(stoi(mp[YYText()][2])+1)};
                                                      mp[YYText()] = {YYText(),"Operator",to_string(stoi(mp[YYText()][2])+1)};                    
                                                  }
                                               }


{Separator}                                      {if(mp.find(YYText())==mp.end()){
                                                        mp[YYText()] = {YYText(),"Separator","1"};
                                                        vec.push_back({YYText(),"Separator","1"});
                                                 }
                                                  else{
                                                     auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                     vec[it-vec.begin()] = {YYText(),"Separator",to_string(stoi(mp[YYText()][2])+1)};
                                                     mp[YYText()] = {YYText(),"Separator",to_string(stoi(mp[YYText()][2])+1)};                    
                                                  }
                                                }


{Identifier}                                     {if(mp.find(YYText())==mp.end()){
                                                        mp[YYText()] = {YYText(),"Identifier","1"};
                                                        vec.push_back({YYText(),"Identifier","1"});
                                                 }
                                                  else{
                                                     auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                     vec[it-vec.begin()] = {YYText(),"Identifier",to_string(stoi(mp[YYText()][2])+1)};
                                                     mp[YYText()] = {YYText(),"Identifier",to_string(stoi(mp[YYText()][2])+1)};                    
                                                  }
                                                }


{Literal}                                         {if(mp.find(YYText())==mp.end())
                                                   {
                                                        mp[YYText()] = {YYText(),"Literal","1"};
                                                        vec.push_back({YYText(),"Literal","1"});
                                                 }
                                                  else{
                                                     auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                     vec[it-vec.begin()] = {YYText(),"Literal",to_string(stoi(mp[YYText()][2])+1)};
                                                     mp[YYText()] = {YYText(),"Literal",to_string(stoi(mp[YYText()][2])+1)};                    
                                                  }
                                                }




{Comment}                                         /* This is to eat up comments and return nothing */


{Whitespace}                                      /* This is to eat up blanks,whitespace and line terminators */


.                                                {printf("Error: Illegal character %s, in line number %d\n",YYText(),yylineno);
                                                 return 0;
                                                 }
%%


int main(int argc, char **argv)
{
++argv, --argc;      /* Skip over the program name */
FlexLexer* scanner = new yyFlexLexer;
ifstream input;
if (argc > 0){
  input.open(argv[0]);
  scanner->switch_streams(input,cout);
}
scanner->yylex();
ofstream outputFile("output.csv");
outputFile << "Lexeme"<<","<<"Token"<<","<<"Count"<<"\n";
for(auto i=vec.begin();i!=vec.end();i++){
  outputFile<< (*i)[0]<<","<<(*i)[1]<<","<<(*i)[2]<<"\n";
}
outputFile.close();
return 0;
}



