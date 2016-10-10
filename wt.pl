use strict;

undef $/;

my $f = <>;

$f =~ s/.*\nSTART/\n/s;
$f =~ s/\nEND.*/\n/s;

my @out;

foreach my $par (split /\n\n+/, $f){
	chomp;
	$par =~ s/^\s*===\s*(.*?)\s*===\s*$/\\paragraph*{$1}\n/;
	$par =~ s/^\s*===\s*(.*?)\s*===\s*\n/\\paragraph*{$1}\n/;
	$par =~ s/^\s*==\s*(.*?)\s*==\s*$/\\subsection*{$1}\n/;
	$par =~ s/^\s*=\s*(.*?)\s*=\s*$/\\section*{$1}\n/;

	# Tables
	$par =~ s/INSERT_TABLE\s+(\w+)\s+(.*?)\.\s+(.*)/\\begin{table}[!hbt]\\input{$2.tex}\\caption{$3}\\label{$1.tab}\\end{table}/g;
	$par =~ s/\(TABLE\s*(.*?)\)/\\tref{$1}/g;

	$par =~ s/MISSING_TABLE\s+(\w+)\s+(.*?)\.\s+(.*)/\\begin{table}[!hbt]\textbf{SKIPPING TABLE}\\caption{$3}\\label{$1.tab}\\end{table}/;

	# Figures
	$par =~ s/INSERT_FIGURE\s+(\w+)\s+(.*?)\.\s+(.*)/\\begin{figure}[!hbt]\\includegraphics[width=0.9\\textwidth]{$2.pdf}\\caption{$3}\\label{$1.fig}\\end{figure}/g;
	$par =~ s/\(FIGURE\s*(.*?)\)/\\fref{$1}/g;

	my @spans = split(/\$\$/, $par);
	push @spans, "" if $par =~ /\$\$$/;
	push @spans, "WARNING: Could not parse this line for equations -- Last element $#spans is odd" if $#spans%2;

	for (my $sn=0; $sn<=$#spans; $sn++){
		if($sn%2){
			# Wrap equations, then leave them alone
			$spans[$sn] =~ s/.*/\\($&\\)/;
		} else {
			# Detoxify other stuff, respect a few markup things
			$spans[$sn] =~ s/[\$#@%^&]/\\$&/g;
			$spans[$sn] =~ s/[<>]/\$$&\$/g;
			$spans[$sn] =~ s/\*,/,/g;
			$spans[$sn] =~ s/'''(.*?)'''/\\textbf{$1}/g;
			$spans[$sn] =~ s/''(.*?)''/\\emph{$1}/g;
			$spans[$sn] =~ s/"([^"]*)"/``$1''/g;

			$spans[$sn] =~ s/\(\(([^)]*?)\s*(\[.*?\]\s*)\)\)/\\cite$2\{$1}/gs;
			$spans[$sn] =~ s/\(\((.*?)\)\)/\\cite{$1}/gs;
		}
	}

	push @out, join "", @spans;
}

my $doc = join "\n\n", @out;
print "$doc";
