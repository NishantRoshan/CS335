%{
    #include <bits/stdc++.h>
   
    using namespace std;
   
    map<string,vector<string> > mp;
    vector<vector<string> > vec;
    
%}

%option c++
%option noyywrap
%option yylineno

KEYWORD       array|begin|case|const|do|downto|else|end|file|for|function|goto|if|label|nil|of|packed|procedure|program|record|repeat|set|then|to|type|until|var|while|with
IDENTIFIER    [a-zA-Z][a-zA-Z0-9]*
STRING        \"([^\\\n"]|(\\.))*?\"
DIGITS        [0-9]+

%%
{KEYWORD}                                        {if(mp.find(yytext)==mp.end()){
                                                         mp[yytext] = {yytext,"Keyword","1"};
                                                         vec.push_back({yytext,"Keyword","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[yytext]);
                                                      vec[it-vec.begin()] = {yytext,"Keyword",to_string(stoi(mp[yytext][2])+1)};
                                                      mp[yytext] = {yytext,"Keyword",to_string(stoi(mp[yytext][2])+1)};                     
                                                   }
                                                 }

"+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|"<="|">="|">"|"^"|and|or|not|div|mod|in               {if(mp.find(yytext)==mp.end()){
                                                                                                    mp[yytext] = {yytext,"Operator","1"};
                                                                                                    vec.push_back({yytext,"Operator","1"});
                                                                                             }
                                                                                                else{
                                                                                                   auto it = find(vec.begin(),vec.end(),mp[yytext]);
                                                                                                   vec[it-vec.begin()] = {yytext,"Operator",to_string(stoi(mp[yytext][2])+1)};
                                                                                                   mp[yytext] = {yytext,"Operator",to_string(stoi(mp[yytext][2])+1)};                     
                                                                                                }
                                                                                             }

","|";"|":"|"("|")"|"["|"]"|".."                 {if(mp.find(yytext)==mp.end()){
                                                         mp[yytext] = {yytext,"Separator","1"};
                                                         vec.push_back({yytext,"Separator","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[yytext]);
                                                      vec[it-vec.begin()] = {yytext,"Separator",to_string(stoi(mp[yytext][2])+1)};
                                                      mp[yytext] = {yytext,"Separator",to_string(stoi(mp[yytext][2])+1)};                     
                                                   }
                                                 }

{IDENTIFIER}                                     {if(mp.find(yytext)==mp.end()){
                                                         mp[yytext] = {yytext,"Identifier","1"};
                                                         vec.push_back({yytext,"Identifier","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[yytext]);
                                                      vec[it-vec.begin()] = {yytext,"Identifier",to_string(stoi(mp[yytext][2])+1)};
                                                      mp[yytext] = {yytext,"Identifier",to_string(stoi(mp[yytext][2])+1)};                     
                                                   }
                                                 }

{STRING}                                         {if(mp.find(yytext)==mp.end()){
                                                         mp[yytext] = {yytext,"String","1"};
                                                         vec.push_back({yytext,"String","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[yytext]);
                                                      vec[it-vec.begin()] = {yytext,"String",to_string(stoi(mp[yytext][2])+1)};
                                                      mp[yytext] = {yytext,"String",to_string(stoi(mp[yytext][2])+1)};                     
                                                   }
                                                 }

{DIGITS}("."{DIGITS})?([Ee][+-]?{DIGITS})?         {if(mp.find(yytext)==mp.end()){
                                                         mp[yytext] = {yytext,"Literal","1"};
                                                         vec.push_back({yytext,"Literal","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[yytext]);
                                                      vec[it-vec.begin()] = {yytext,"Literal",to_string(stoi(mp[yytext][2])+1)};
                                                      mp[yytext] = {yytext,"Literal",to_string(stoi(mp[yytext][2])+1)};                     
                                                   }
                                                 }

"{"[^}]*"}"                                      /* This is to eat up comments and return nothing */

[ \t\n\r\f]                                      /* This is to eat up blanks,whitespace and line terminators */

.                                                {printf("Error: Illegal character %s in line number %d\n",yytext,yylineno);
                                                  return 0;
                                                  }
%%
/*** User code section***/

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