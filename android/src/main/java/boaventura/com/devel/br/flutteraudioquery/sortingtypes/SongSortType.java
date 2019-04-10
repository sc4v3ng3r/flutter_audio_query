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

public enum SongSortType {
    DEFAULT,

    /**
     * Returns the songs sorted using [composer] property as sort
     * parameter.*/
    ALPHABETIC_COMPOSER,

    /**
     * Returns the songs sorted using [duration] property as
     * sort parameter. In this case the songs with greatest
     * duration in milliseconds will come first.
     */
    GREATER_DURATION,

    /**
     * Returns the songs sorted using [duration] property as
     * sort parameter. In this case the songs with smaller
     * duration in milliseconds will come first.
     */
    SMALLER_DURATION,

    /**
     * Returns the songs sorted using [year] property as
     * sort parameter. In this case the songs that has more
     * recent year will come first.
     * */
    RECENT_YEAR,

    /**Returns the songs sorted using [year] property as
     * sort parameter. In this case the songs that has more
     * oldest year will come first.
     */
    OLDEST_YEAR,

    /**
     * Returns the songs alphabetically sorted using [artist] property as
     * sort parameter. In this case*/
    ALPHABETIC_ARTIST,

    /**
     * Returns the songs alphabetically sorted using [album] property as
     * sort parameter. In this case*/
    ALPHABETIC_ALBUM,

    /**
     *  Returns the songs sorted using [track] property as sort param.
     *  The songs with greater track number will come first.
     *  NOTE: In Android platform [track] property number encodes both the track
     *  number and the disc number. For multi-disc sets, this number will be 1xxx
     *  for tracks on the first disc, 2xxx for tracks on the second disc, etc.
     */
    GREATER_TRACK_NUMBER,

    /**
     * Returns the songs sorted using [track] property as sort param.
     * The songs with smaller track number will come first.
     * NOTE: In Android platform [track] property number encodes both the track
     * number and the disc number. For multi-disc sets, this number will be 1xxx
     * for tracks on the first disc, 2xxx for tracks on the second disc, etc
     */
    SMALLER_TRACK_NUMBER,

    /**
     * Return the songs sorted using [display_name] property as sort param.
     * Is a good option to used when desired have the original album songs order.
     * */
    DISPLAY_NAME
}
