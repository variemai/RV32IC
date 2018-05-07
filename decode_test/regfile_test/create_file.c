#include <stdio.h>

int main(int argc, char **argv){
	FILE *fp;
	int i;
	fp=fopen(argv[1],"w");
	if(fp==NULL) {
		printf("Cannot Create File\n");
		return -1;
	}
	for(i=0; i<32; i++){
		fprintf(fp,"%x\n",i);
	}
	fclose(fp);
	return 0;
}
