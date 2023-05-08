%{
    #include <iostream>
    #include <vector>
    #include <string>
    #include <unordered_map>
    #include <utility> 

    using namespace std;

    extern FILE* yyin;
    extern int yylex();
    extern int yyparse();
    void yyerror(const char* s);

    vector<string> vec;
    int words=0, dec_sentences=0, ex_sentences=0, inter_sentences=0, paragraphs=0, sections=0, chapters=0;
    
%}

%union{
    char* str;
}

%token T_WORD T_NUMERAL T_EOL T_PARASEP T_WSEP 
%token T_TITLE T_CHAPTER T_SECTION
%token T_SSEP
%type <str> T_TITLE T_CHAPTER T_SECTION
%type <str>  T_SSEP
/* %type<str> T_WORD */
%start dissertation
%error-verbose
%%

dissertation : T_TITLE chapters              {printf("%s",$1);}
chapters: chapter chapters 
        | chapter
chapter : T_CHAPTER follow                    {chapters++;
                                               string s = $1;
                                               while(s.back() == '\n')
                                               s.pop_back();
                                               s.push_back('\n');
                                               vec.push_back(s);}
follow : sections
       | paragraphs sections
       | paragraphs
sections : section 
         | section sections
section : T_SECTION paragraphs                {sections++;
                                               string s = $1;
                                               while(s.back() == '\n')
                                               s.pop_back();
                                               s.push_back('\n');
                                               vec.push_back(s);}
paragraphs : paragraph paragraphs   
           | paragraph
paragraph : sentence paragraph 
          | sentence T_PARASEP                {paragraphs++;}
          | sentence T_EOL                    {paragraphs++;}

sentence : literals sentence_separator        
sentence_separator : T_SSEP                   {string s = $1;
                                               if(s == ".") dec_sentences++;
                                               if(s == "!") ex_sentences++;
                                               if(s == "?") inter_sentences++;}
literals : /*  epsilon  */
         | T_WORD literals                    {words++;}
         | T_NUMERAL literals

%%


int main(int argc, char** argv){
    ++argv, --argc;      /* Skip over the program name */
    if(argc > 0){
        FILE * pt = fopen(argv[0], "r" );
        if(!pt){
            cout << "Bad Input . No existant file" << endl;
            return 0;
        }
        yyin = pt;
        do
        {
           yyparse();
        }while (!feof(yyin));
        fclose(yyin);
        cout<< "Number of chapters: " << chapters << "\n";
        cout<< "Number of sections: " << sections << "\n";
        cout<< "Number of paragraphs: " << paragraphs << "\n";
        cout<< "Number of sentences: " << dec_sentences+ex_sentences+inter_sentences <<"\n";
        cout<< "Number of words: " << words <<"\n"<<"\n";
        cout<< "Number of declarative sentences: " <<dec_sentences <<"\n";
        cout<< "Number of exclamatory sentences: " <<ex_sentences <<"\n";
        cout<< "Number of interrogative sentences: " <<inter_sentences <<"\n"<<"\n";
        cout<< "Table of contents: \n";
        int count =0,flag =0;
        for(int i=0;i<vec.size();i++){
            if(vec[i][0] == 'S'){
                if(!flag){
                    count++;
                    continue;
                }
                cout<<"\t"<<vec[i]<<"\n";
                continue;
            }
            if(!flag){
                cout<< vec[i] <<"\n";
                flag=1;
                i = i-count-1;
                continue;
            }
            if(!flag)
            cout<< vec[i] <<"\n";
            flag =0;
            count =0;
        }
    }else{
        cout<< "Provide filename as argument\n";
    }
    return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}