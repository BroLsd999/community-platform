package DDGC::DB::Result::Token::Language::Translation;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn' ];
use DateTime;

table 'token_language_translation';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column msgstr0 => {
	data_type => 'text',
	is_nullable => 0,
};
sub msgstr { shift->msgstr0(@_) }

column msgstr1 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr2 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr3 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr4 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr5 => {
	data_type => 'text',
	is_nullable => 1,
};

sub msgstr_index_max { 5 }

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column token_language_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column check_result => {
	data_type => 'int',
	is_nullable => 1,
};

column check_timestamp => {
	data_type => 'timestamp with time zone',
	is_nullable => 1,
};

column check_users_id => {
	data_type => 'bigint',
	is_nullable => 1,
};
sub checked { shift->check_users_id ? 1 : 0 }

# column users_id => {
	# data_type => 'bigint',
	# is_nullable => 0,
# };
column username => {
	data_type => 'text',
	is_nullable => 0,
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

unique_constraint [qw/ token_language_id username /];

#belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'user', 'DDGC::DB::Result::User', { 'foreign.username' => 'self.username' };
belongs_to 'token_language', 'DDGC::DB::Result::Token::Language', 'token_language_id';
belongs_to 'check_user', 'DDGC::DB::Result::User', 'check_users_id', { join_type => 'left' };

has_many 'token_language_translation_votes', 'DDGC::DB::Result::Token::Language::Translation::Vote', 'token_language_translation_id';

sub set_check {
	my ( $self, $user, $check ) = @_;
	if ($user->translation_manager) {
		$self->check_result($check ? 1 : 0);
		$self->check_users_id($user->id);
		$self->check_timestamp(DateTime->now);
	} else {
		die "you are not a translation manager, you cant check the translation!";
	}
}

sub set_user_vote {
	my ( $self, $user, $vote ) = @_;
	if ($vote) {
		$self->update_or_create_related('token_language_translation_votes',{
			user => $user->db,
		},{
			key => 'token_language_translation_token_language_id_users_id',
		});
	} else {
		$self->search_related('token_language_translation_votes',{
			user => $user->db,
		})->delete;
	}
}

sub key {
	my ( $self ) = @_;
	my $key;
	for (0..$self->msgstr_index_max) {
		my $func = 'msgstr'.$_;
		$key .= $self->$func ? $self->$func : '';
	}
	return $key;
}

use overload '""' => sub {
	my $self = shift;
	return 'Token-Language-Translation #'.$self->id;
}, fallback => 1;

1;
