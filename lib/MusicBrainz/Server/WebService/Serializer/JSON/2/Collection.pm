package MusicBrainz::Server::WebService::Serializer::JSON::2::Collection;
use Moose;
use MusicBrainz::Server::WebService::Serializer::JSON::2::Utils qw(
  count_of
  list_of
  number
  serialize_entity
);
use MusicBrainz::Server::Constants qw( %ENTITIES );

extends 'MusicBrainz::Server::WebService::Serializer::JSON::2';
with 'MusicBrainz::Server::WebService::Serializer::JSON::2::Role::GID';

sub serialize
{
    my ($self, $entity, $inc, $stash, $toplevel) = @_;
    my %body;

    $body{name} = $entity->name;
    $body{editor} = $entity->editor->name;
    $body{type} = $entity->type ? $entity->type->name : JSON::null;
    $body{"entity-type"} = $entity->type ? $entity->type->entity_type : JSON::null;

    my $entity_type = $entity->type->entity_type;
    my $plural = $ENTITIES{$entity_type}{plural} // $entity_type . 's';
    my $url = $ENTITIES{$entity_type}{url} // $entity_type;
    my $plural_url = $ENTITIES{$entity_type}{plural} // $url . 's';

    if ($toplevel) {
        $body{"$url-count"} = count_of($entity, $inc, $stash, $plural);
        $body{$plural_url} = list_of($entity, $inc, $stash, $plural);
    }

    if ($entity->loaded_entity_count) {
        $body{"$url-count"} = number($entity->entity_count);
    }

    return \%body;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;

# =head1 COPYRIGHT

# Copyright (C) 2012 MetaBrainz Foundation

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

# =cut

