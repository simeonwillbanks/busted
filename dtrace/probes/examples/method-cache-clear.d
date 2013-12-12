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
 * https://github.com/ruby/ruby/blob/trunk/doc/dtrace_probes.rdoc
 */
ruby$target:::method-cache-clear
/arg1/
{
    printf("%s %s %d\n", copyinstr(arg0), copyinstr(arg1), arg2);
}
