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

public enum AlbumSortType {
    DEFAULT,

    /**Returns the albums sorted in alphabetic order using the album [artist]
     * property as sort parameter
     */
    ALPHABETIC_ARTIST_NAME,


    //static const String MOST_RECENT_FIRST_YEAR = "MOST_RECENT_FIRST_YEAR";
    //static const String MOST_RECENT_LAST_YEAR = "MOST_RECENT_LAST_YEAR";

    /**
     * Returns the albums sorted using [numberOfSongs] property as sort
     * parameter. In This case the albums with more number of songs will
     * come first.
     */
    MORE_SONGS_NUMBER_FIRST,

    /**
      * Returns the albums sorted using [numberOfSongs] property as sort
      * parameter. In This case the albums with less number of songs will
      * come first.
      * */
    LESS_SONGS_NUMBER_FIRST,

    /**
     * Returns the albums sorted using [lastYear] property as sort param.
     * In this case the albums with more recent year value will come first.
     * */
    MOST_RECENT_YEAR,

    /**
     * Returns the albums sorted using [lastYear] property as sort param.
     * In this case the albums with more oldest year value will come first.
     * */
    OLDEST_YEAR,
}
