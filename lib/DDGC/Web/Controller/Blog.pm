package DDGC::Web::Controller::Blog;

use Moose;
BEGIN {extends 'DDGC::Web::ControllerBase::Blog'; }

use namespace::autoclean;

sub index_title { 'Latest DuckDuckGo Blog posts' }

sub base :Chained('/base') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	push @{$c->stash->{template_layout}}, 'blog/base.tx';
	$c->stash->{page_class} = "page-blog texture";
	$c->stash->{blog_resultset} = $c->d->rs('User::Blog')->search({
		company_blog => 1,
		($c->user && $c->user->admin) ? () : ( live => 1 ),
	});
    $c->add_bc('DuckDuckGo Blog posts', $c->chained_uri('Blog', 'index'));
}

1;
