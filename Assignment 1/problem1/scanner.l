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
{KEYWORD}                                        {if(mp.find(YYText())==mp.end()){
                                                         mp[YYText()] = {YYText(),"Keyword","1"};
                                                         vec.push_back({YYText(),"Keyword","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                      vec[it-vec.begin()] = {YYText(),"Keyword",to_string(stoi(mp[YYText()][2])+1)};
                                                      mp[YYText()] = {YYText(),"Keyword",to_string(stoi(mp[YYText()][2])+1)};                     
                                                   }
                                                 }

"+"|"-"|"*"|"/"|"."|":="|"="|"<>"|"<"|"<="|">="|">"|"^"|and|or|not|div|mod|in               {if(mp.find(YYText())==mp.end()){
                                                                                                    mp[YYText()] = {YYText(),"Operator","1"};
                                                                                                    vec.push_back({YYText(),"Operator","1"});
                                                                                             }
                                                                                                else{
                                                                                                   auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                                                                   vec[it-vec.begin()] = {YYText(),"Operator",to_string(stoi(mp[YYText()][2])+1)};
                                                                                                   mp[YYText()] = {YYText(),"Operator",to_string(stoi(mp[YYText()][2])+1)};                     
                                                                                                }
                                                                                             }

","|";"|":"|"("|")"|"["|"]"|".."                 {if(mp.find(YYText())==mp.end()){
                                                         mp[YYText()] = {YYText(),"Separator","1"};
                                                         vec.push_back({YYText(),"Separator","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                      vec[it-vec.begin()] = {YYText(),"Separator",to_string(stoi(mp[YYText()][2])+1)};
                                                      mp[YYText()] = {YYText(),"Separator",to_string(stoi(mp[YYText()][2])+1)};                     
                                                   }
                                                 }

{IDENTIFIER}                                     {if(mp.find(YYText())==mp.end()){
                                                         mp[YYText()] = {YYText(),"Identifier","1"};
                                                         vec.push_back({YYText(),"Identifier","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                      vec[it-vec.begin()] = {YYText(),"Identifier",to_string(stoi(mp[YYText()][2])+1)};
                                                      mp[YYText()] = {YYText(),"Identifier",to_string(stoi(mp[YYText()][2])+1)};                     
                                                   }
                                                 }

{STRING}                                         {if(mp.find(YYText())==mp.end()){
                                                         mp[YYText()] = {YYText(),"String","1"};
                                                         vec.push_back({YYText(),"String","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                      vec[it-vec.begin()] = {YYText(),"String",to_string(stoi(mp[YYText()][2])+1)};
                                                      mp[YYText()] = {YYText(),"String",to_string(stoi(mp[YYText()][2])+1)};                     
                                                   }
                                                 }

{DIGITS}("."{DIGITS})?([Ee][+-]?{DIGITS})?         {if(mp.find(YYText())==mp.end()){
                                                         mp[YYText()] = {YYText(),"Literal","1"};
                                                         vec.push_back({YYText(),"Literal","1"});
                                                  }
                                                   else{
                                                      auto it = find(vec.begin(),vec.end(),mp[YYText()]);
                                                      vec[it-vec.begin()] = {YYText(),"Literal",to_string(stoi(mp[YYText()][2])+1)};
                                                      mp[YYText()] = {YYText(),"Literal",to_string(stoi(mp[YYText()][2])+1)};                     
                                                   }
                                                 }

"{"[^}]*"}"                                      /* This is to eat up comments and return nothing */

[ \t\n\r\f]                                      /* This is to eat up blanks,whitespace and line terminators */

.                                                {printf("Error: Illegal character %s in line number %d\n",YYText(),yylineno);
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