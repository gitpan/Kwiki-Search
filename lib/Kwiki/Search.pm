package Kwiki::Search;
use strict;
use warnings;
use Kwiki::Plugin '-Base';
use Kwiki::Installer '-base';
use Kwiki ':char_classes';
our $VERSION = '0.10';

const class_id => 'search';
const class_title => 'Search';
const cgi_class => 'Kwiki::Search::CGI';
const screen_template => 'search_screen.html';
const css_file => 'search.css';

sub register {
    my $registry = shift;
    $registry->add(action => 'search');
    $registry->add(toolbar => 'search_box', 
                   template => 'search_box.html',
                  );
}

sub search {
    $self->render_screen(pages => $self->perform_search);
}

sub perform_search {
    my $search = $self->cgi->search_term;
    $search =~ s/[^$WORD\ \-\.\^\$\*\|\:]//g;
    [ 
        grep {
            $_->content =~ m{$search}i and 
            $_->active
        } $self->pages->all 
    ]
}

package Kwiki::Search::CGI;
use Kwiki::CGI '-base';

cgi 'search_term';

1;

package Kwiki::Search;
__DATA__

=head1 NAME 

Kwiki::Search - Kwiki Search Plugin

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Brian Ingerson <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2004. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
__template/tt2/search_box.html__
<!-- BEGIN search_box.html -->
<form method="post" action="[% script_name %]" enctype="application/x-www-form-urlencoded" style="display: inline">
<input type="text" name="search_term" size="8" value="Search" onfocus="this.value=''" />
<input type="hidden" name="action" value="search" />
</form>
<!-- END search_box.html -->
__template/tt2/search_screen.html__
<!-- BEGIN search_screen.html -->
[% screen_title = 'Search Results' %]
[% INCLUDE kwiki_layout_begin.html %]
<table class="search">
[% FOR page = pages %]
<tr>
<td class="page_id">[% page.kwiki_link %]</td>
<td class="edit_by">[% page.edit_by_link %]</td>
<td class="edit_time">[% page.edit_time %]</td>
</tr>
[% END %]
</table>
[% INCLUDE kwiki_layout_end.html %]
<!-- END search_screen.html -->
__css/search.css__
table.search {
    width: 100%;
}

table.search td {
    white-space: nowrap;
    padding: .2em 1em .2em 1em;
}

table.search td.page_id   { 
    text-align: left;
}
table.search td.edit_by   { 
    text-align: center;
}
table.search td.edit_time { 
    text-align: right;
}

