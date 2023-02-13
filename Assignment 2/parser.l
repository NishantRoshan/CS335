%{
    #include <iostream>
    #include <string>
    #include <vector>
    #include <unordered_map>
    #include <utility> 
    using namespace std;
    
    #include "parser.tab.h"
    #define YY_DECL int yylex()

%}

%option noyywrap
%option yylineno

TITLE                    "Title".*\n
SECTION                  "Section".*\n
CHAPTER                  "Chapter".*\n
SENTENCE_SEPARATOR       "."|"!"|"?"
WHITESPACE               [ ]+
WORD_SEPARATOR           {WHITESPACE}|","|";"
PARAGRAPH_SEPARATOR      \n{2,}
DIGIT                    [0-9]
NUMERAL                  {WORD_SEPARATOR}*[+-]?{DIGIT}+("."{DIGIT}+)?{WORD_SEPARATOR}*
WORD                     {WORD_SEPARATOR}*[a-zA-Z]+{WORD_SEPARATOR}*
EOL                      \n


%%
{TITLE}{EOL}*             {yylval.str = strdup(yytext);
                           return T_TITLE;}
{SECTION}{EOL}*           {yylval.str = strdup(yytext);
                           return T_SECTION;}
{CHAPTER}{EOL}*           {yylval.str = strdup(yytext);
                           return T_CHAPTER;}
{SENTENCE_SEPARATOR}      {yylval.str = strdup(yytext);
                           return T_SSEP;}
{WORD_SEPARATOR}          {yylval.str = strdup(yytext);
                           return T_WSEP;}
{NUMERAL}                 {yylval.str = strdup(yytext);
                           return T_NUMERAL;}
{PARAGRAPH_SEPARATOR}     {yylval.str = strdup(yytext);
                           return T_PARASEP;}
{WORD}                    {yylval.str = strdup(yytext);
                           return T_WORD;}
{EOL}                     {return T_EOL;}

%%


