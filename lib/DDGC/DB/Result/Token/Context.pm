package DDGC::DB::Result::Token::Context;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'SingletonRows', 'EncodedColumn' ];

table 'token_context';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column name => {
	data_type => 'text',
	is_nullable => 0,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

column updated => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
	set_on_update => 1,
};

has_many 'tokens', 'DDGC::DB::Result::Token', 'token_context_id';

use overload '""' => sub {
	my $self = shift;
	return 'Token Context '.$self->name.' #'.$self->id;
}, fallback => 1;

1;
