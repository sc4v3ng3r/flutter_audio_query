//Copyright (C) <2019>  <Marcos Antonio Boaventura Feitoza> <scavenger.gnu@gmail.com>
//
//        This program is free software: you can redistribute it and/or modify
//        it under the terms of the GNU General Public License as published by
//        the Free Software Foundation, either version 3 of the License, or
//        (at your option) any later version.
//
//        This program is distributed in the hope that it will be useful,
//        but WITHOUT ANY WARRANTY; without even the implied warranty of
//        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//        GNU General Public License for more details.
//
//        You should have received a copy of the GNU General Public License
//        along with this program.  If not, see <http://www.gnu.org/licenses/>.


package boaventura.com.devel.br.flutteraudioquery.sortingtypes;

public enum ArtistSortType {
    DEFAULT,

    /**
     * Returns the artists sorted using the number of albums as sorting parameter.
     * In this case the artists with more number of albums comes first.
     */
    MORE_ALBUMS_NUMBER_FIRST,

    /**
     * Returns the artists sorted using the number of albums as sorting parameter.
     * In this case the artists with less number of albums comes first.
     */
    LESS_ALBUMS_NUMBER_FIRST,

    /**
     * Returns the artists sorted using the number of tracks as sorting parameter.
     * In this case the artists with more number of tracks comes first.
     */
    MORE_TRACKS_NUMBER_FIRST,

    /**
     * Returns the artists sorted using the number of tracks as sorting parameter.
     * In this case the artists with less number of tracks comes first.
     */
    LESS_TRACKS_NUMBER_FIRST,
}
