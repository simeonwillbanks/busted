dtrace:::BEGIN
{
	printf("Busted Trace Started.\n");
}
ruby$target:::method-cache-clear
/arg1/
{
    printf("%s %s %d\n", copyinstr(arg0), copyinstr(arg1), arg2);
}
ruby$target:::raise
/arg1/
{
    printf("%s %s %d\n", copyinstr(arg0), copyinstr(arg1), arg2);
}
