/*
 * method-cache-clear.d dtrace probe
 *
 * Prints invalidation Class, Source File, and Line Number to STDOUT.
 *
 * Example Usage:
 *
 * $ sudo dtrace -q -s ./method-cache-clear.d -p <pid of running ruby process>
 * global test/busted_test.rb 78
 * Hello test/busted_test.rb 66
 *
 * More DTrace/Ruby Examples:
 *
 * http://magazine.rubyist.net/?Ruby200SpecialEn-dtrace
 *
 * Documentation:
 *
 * http://ruby-doc.org/core-2.1.0/doc/dtrace_probes_rdoc.html
 */
ruby$target:::method-cache-clear
/arg1/
{
    printf("%s %s %d\n", copyinstr(arg0), copyinstr(arg1), arg2);
}
