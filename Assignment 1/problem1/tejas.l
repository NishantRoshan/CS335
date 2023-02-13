%{
	/*
*/
#include <iostream>
#include <string>
#include<vector>
#include <unordered_map>
#include<utility> 
using namespace std;
unordered_map<string, pair<int,string> > m;
vector<string> v;
vector<string> error;
string s;
int ret;
int line_num=1;
void func(string s, string token);
FILE* fp;

%}


DIGIT [0-9]
INTEGER [1-9][0-9]*
FLOAT {INTEGER}|{INTEGER}"."{DIGIT}+ 
EXPONENT [Ee][-]?[0-9]+
ID [a-zA-Z][a-zA-Z0-9]* 
KEYWORD array|begin|case|const|do|downto|else|end|file|for|function|goto|if|label|nil|of|packed|procedure|program|record|repeat|set|then|to|type|until|var|while|with
OPERATOR "+"|"-"|"*"|"/"|":="|"="|"<>"|"<"|"<="|">="|">"|"^"|and|or|not|div|mod|in
SEPARATOR ","|";"|":"|"("|")"|"["|"]"|".."
STRING ["][^\n"]*["]
BLANK [\t\f ]
%%

{KEYWORD} {func(yytext, "Keyword");}
{OPERATOR} {func(yytext, "Operator");}
{SEPARATOR} {func(yytext, "Separator");}
{ID}"."{ID} {
		 int l= yyleng;
		 int i=0;
		s= yytext;	
		while(s[i]!='.')
		{
			i++;
		}
		s= s.substr(0,i);
		// cout<<"First part of string is "<<s<<" ";
		func(s, "Identifier");
		s=".";
		func(s, "Operator");
		s= yytext;
		s= s.substr(i+1, l-i+1);
		func(s, "Identifier");
		// cout<<"Second part of string is "<<s<<" ";
}
{ID}"."{DIGIT} {
		 int l= yyleng;
		 int i=0;
		s= yytext;	
		while(s[i]!='.')
		{
			i++;
		}
		s= s.substr(0,i);
		// cout<<"First part of string is "<<s<<" ";
		func(s, "Identifier");
		s=".";
		func(s, "Operator");
		s= s.substr(i+1, l-i+1);
		func(s, "Literal");
		// cout<<"Second part of string is "<<s<<" ";
}
{FLOAT}".."{FLOAT} {
		 int l= yyleng;
		 int i=0;
		s= yytext;	
		while(1)
		{
			while(s[i]!='.')
			{
				i++;
			}
			if(s[i+1]=='.') break;
			else i++;
		}
		s= s.substr(0,i);
		// cout<<"First part of string is "<<s<<" ";
		func(s, "Literal");
		s="..";
		func(s, "Operator");
		s= yytext;
		s= s.substr(i+2, l-i+1);
		func(s, "Literal");
		// cout<<"Second part of string is "<<s<<" ";
}
"{" {
		 int c;
		// fprintf(stdout, "hello\n");
		while(1)
		{
			while ( (c = yyinput()) != '}' && (c != EOF) && c!='\0' )
			{
				if(c=='\n') line_num++;
			}
			if ( c == '}')
			{
				break;
			}
			if ( c == EOF  || c=='\0')
			{
				fprintf( stdout,"EOF in comment on line %d\n", line_num);
				break;
			}
		}
	}
{ID} {func(yytext, "Identifier");}
{STRING} {func(yytext, "Literal");}
[-]?{DIGIT}+[.]?{DIGIT}*{EXPONENT}? {func(yytext, "Literal");}
\n line_num++;
{BLANK} {}
. { fprintf(stdout, "Error due to illegal character %s on line number %d\n", yytext, line_num);return 1;}

%%

int yywrap(void) {return 1;}

void func(string s, string token)
{
	if(m.find(s)==m.end()) 
	{
		pair<int, string> p;
		p.first= 1;
		p.second= token;
		m[s]=p;
		v.push_back(s);
	}
	else 
	{
		m[s].first++;
	}
	return;
}


int main(int argc, char **argv ){
	
	if ( argc ==2 ) 
	{
		fp=  fopen( argv[1], "r" );
		if(fp==NULL) 
		{
			fprintf(stdout, "Error in opening file, please try again by placing file in same directory");
		 	return 2;
		}
		else yyin= fp;
	}
	ret= yylex();

	yyout=  fopen("MyFile.csv", "w+");
	if (!yyout) {
        fprintf(yyout, "Can't open file\n");
    }
	fprintf(yyout,"Lexeme , Token , Count\n");
	for(int i=0;i<v.size();i++)
	{
		fprintf(yyout, "%s , %s , %d\n", v[i].c_str(), m[v[i]].second.c_str(), m[v[i]].first);
	}
	cout<<line_num<<"\n";
}