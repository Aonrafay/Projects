#include <iostream>   // For input/output operations
#include <fstream>    // To read from a file
#include <vector>     // To use the vector data structure
#include <string>     // To use string for text
#include <algorithm>  // For random shuffling
#include <cstdlib>    // For random number functions
#include <ctime>      // To seed random numbers using current time
using namespace std ;


void mcqsload ( string& filename , vector<string>& mcqs )
{
    ifstream file (filename) ;
    string line , question ;
    while (getline (file,line))
    {
        if (line.empty())
        {
             
             
                mcqs.push_back(question); 
                question.clear();
        }
            else 
            {
                question += line + "\n" ;
            }
        
        
    }
    
    file.close();
    
    
}
void answers (string& filename , vector<string>& ans)
{
    ifstream file (filename);
    string line ;
    while (getline(file,line))
    {
        ans.push_back(line);
        line.clear();
        //cout<<"\n";

    }
    file.close();
}
int main ()
{
    int choice,TQ;
    again:
    cout<<"-------------choice what you  want to go with-------------"<<endl;
    cout<<"1=premade template\n2=custom generation"<<endl;
    cout<<"enter=";
    cin>>choice;
    if(choice==1)
    {
        TQ=30;
    }
    else if(choice==2)
    {
        cout<<"::enter number of mcqs you want to generate::"<<endl;
        cout<<"enter=";
        cin>>TQ;
    }
    else
    {
        cout<<"invalid choice!!";
        goto again ;

    }
    srand(time(0));
    //for mcqs
    vector<string> mcqs ;
    string filename = "mcqs.txt" ;
    mcqsload(filename,mcqs);
    if (mcqs.empty()) {
        cout << "No MCQs found. Please check the file." << endl;
        return 1;
    }
    //for answers 
    vector<string> ans ;
    string answerfile ="answers.txt";
    answers (answerfile,ans);
    // for random numbers
    vector<int> rnum;
    int count = 1 ;
	for (int i = 0; i<TQ ; i++) {
	int num ;
	num = rand() % 101;
	if (num!=0)
	{
		rnum.push_back(num);
	}
	else {};
	};
    //check reapted if any  
    for(int a=0;a<=TQ;a++)
    {
    for(int b=0;b<=TQ;b++)
    {
        if(rnum[a]==rnum[b])
        {
            rnum[a]= rand() % 101;
        }
    }
    }
    // for printing mcqs and answers 
    vector<string> userans (TQ) ;
    int correct=0 ,wrong=0 ;
    for (int j=0; j<TQ ; j++)
    {
        cout << count <<") " << mcqs[rnum[j]] << endl;
        cout<< "your answer=";
        cin >>userans[j];
        if (userans[j] == ans[rnum[j]])
        {
            cout<< " the correct answer "<< endl;
            correct++;
        }
        else {

        cout << "incorrect"  << endl ;
        wrong++;
        }
        count++ ;
    }
    cout<<"------------KEY------------"<<endl;
    for (int k=0;k<TQ;k++)
    {
       cout<< ans[rnum[k]]<<endl;
    }
    cout << "correct answeers="<< correct <<endl ;
    cout << "wrong answers="<< wrong << endl;
    return 0;
	

}