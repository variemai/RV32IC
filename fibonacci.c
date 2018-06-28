int main(void){
    int t1 = 0;
    int t2 = 1; 
    int nextTerm = 0; 
    int n = 1024;


    //printf("Fibonacci Series: %d, %d, ", t1, t2);
    
    nextTerm = t1 + t2;
    
    while(nextTerm <= n){
        //printf("%d, ",nextTerm);
        t1 = t2;
        t2 = nextTerm;
        nextTerm = t1 + t2;
    }
    //printf("\n");        

    return 0;
}
