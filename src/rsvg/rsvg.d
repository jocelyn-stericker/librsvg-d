/* 
   rsvg.d: SAX-based renderer for SVG files into a GdkPixbuf.
 
   Copyright (C) 2000 Eazel, Inc.
  
   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public License as
   published by the Free Software Foundation; either version 2 of the
   License, or (at your option) any later version.
  
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.
  
   You should have received a copy of the GNU Library General Public
   License along with this program; if not, write to the
   Free Software Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.
  
   Author: Raph Levien <raph@artofcode.com>
*/

module rsvg.rsvg;
import cairo.c.cairo;

extern(C) {

alias ulong GType;
alias uint GQuark;

struct GError {
    uint domain;
    int code;
    char* message;
}

// dummies
struct GdkPixbuf {}
struct GObject {}
struct GObjectClass {}
struct GFile {}
struct GInputStream {}
struct GCancellable {}
struct RsvgHandlePrivate {}

GType rsvg_handle_get_type ();

/**
 * RsvgError:
 * @RSVG_ERROR_FAILED: the request failed
 *
 * An enumeration representing possible errors
 */
enum RSvgError {
    RSVG_ERROR_FAILED
}

GQuark rsvg_error_quark ();

/**
 * RsvgHandleClass:
 * @parent: parent class
 *
 * Class structure for #RsvgHandle
 */
struct RsvgHandleClass {
    GObjectClass parent;

    /*< private >*/
    void* _abi_padding[15];
}

/**
 * RsvgHandle:
 *
 * The #RsvgHandle is an object representing the parsed form of a SVG
 */
struct RsvgHandle {
    GObject parent;

    /*< private >*/

    RsvgHandlePrivate *priv;

    void* _abi_padding[15];
}

/**
 * RsvgDimensionData:
 * @width: SVG's width, in pixels
 * @height: SVG's height, in pixels
 * @em: em
 * @ex: ex
 */
struct RsvgDimensionData {
    int width;
    int height;
    double em;
    double ex;
}

/**
 * RsvgPositionData:
 * @x: position on the x axis
 * @y: position on the y axis
 *
 * Position of an SVG fragment.
 */
struct RsvgPositionData {
    int x;
    int y;
}

void rsvg_cleanup ();

void rsvg_set_default_dpi	(double dpi);
void rsvg_set_default_dpi_x_y	(double dpi_x, double dpi_y);

void rsvg_handle_set_dpi	(RsvgHandle * handle, double dpi);
void rsvg_handle_set_dpi_x_y	(RsvgHandle * handle, double dpi_x, double dpi_y);

RsvgHandle  *rsvg_handle_new	();
bool     rsvg_handle_write		(RsvgHandle * handle, const ubyte * buf, 
                                 int count, GError ** error);
bool     rsvg_handle_close		(RsvgHandle * handle, GError ** error);
GdkPixbuf   *rsvg_handle_get_pixbuf	(RsvgHandle * handle);
GdkPixbuf   *rsvg_handle_get_pixbuf_sub (RsvgHandle * handle, const char *id);

const char  *rsvg_handle_get_base_uri (RsvgHandle * handle);
void         rsvg_handle_set_base_uri (RsvgHandle * handle, const char *base_uri);

void rsvg_handle_get_dimensions (RsvgHandle * handle, RsvgDimensionData * dimension_data);

bool rsvg_handle_get_dimensions_sub (RsvgHandle * handle, RsvgDimensionData * dimension_data, const char *id);
bool rsvg_handle_get_position_sub (RsvgHandle * handle, RsvgPositionData * position_data, const char *id);

bool rsvg_handle_has_sub (RsvgHandle * handle, const char *id);

/* GIO APIs */

/**
 * RsvgHandleFlags:
 * @RSVG_HANDLE_FLAGS_NONE: none
 * @RSVG_HANDLE_FLAG_UNLIMITED: Allow any SVG XML without size limitations.
 *   For security reasons, this should only be used for trusted input!
 *   Since: 2.40.3
 * @RSVG_HANDLE_FLAG_KEEP_IMAGE_DATA: Keeps the image data when loading images,
 *  for use by cairo when painting to e.g. a PDF surface. This will make the
 *  resulting PDF file smaller and faster.
 *  Since: 2.40.3
 */
enum RsvgHandleFlags/*< flags >*/ 
{
    NONE            = 0,
    UNLIMITED       = 1 << 0,
    KEEP_IMAGE_DATA = 1 << 1
}

RsvgHandle *rsvg_handle_new_with_flags (RsvgHandleFlags flags);

void rsvg_handle_set_base_gfile (RsvgHandle *handle,
                                 GFile      *base_file);

bool rsvg_handle_read_stream_sync (RsvgHandle   *handle,
                                   GInputStream *stream,
                                   GCancellable *cancellable,
                                   GError      **error);

RsvgHandle *rsvg_handle_new_from_gfile_sync (GFile          *file,
                                             RsvgHandleFlags flags,
                                             GCancellable   *cancellable,
                                             GError        **error);

RsvgHandle *rsvg_handle_new_from_stream_sync (GInputStream   *input_stream,
                                              GFile          *base_file,
                                              RsvgHandleFlags flags,
                                              GCancellable   *cancellable,
                                              GError        **error);

RsvgHandle *rsvg_handle_new_from_data (const ubyte * data, int data_len, GError ** error);
RsvgHandle *rsvg_handle_new_from_file (const ubyte * file_name, GError ** error);

GType rsvg_error_get_type();
GType rsvg_handle_flags_get_type();

/**
 * CSS
 */
enum RsvgAspectRatios {
    RSVG_ASPECT_RATIO_NONE = 0,
    RSVG_ASPECT_RATIO_XMIN_YMIN = 1 << 0,
    RSVG_ASPECT_RATIO_XMID_YMIN = 1 << 1,
    RSVG_ASPECT_RATIO_XMAX_YMIN = 1 << 2,
    RSVG_ASPECT_RATIO_XMIN_YMID = 1 << 3,
    RSVG_ASPECT_RATIO_XMID_YMID = 1 << 4,
    RSVG_ASPECT_RATIO_XMAX_YMID = 1 << 5,
    RSVG_ASPECT_RATIO_XMIN_YMAX = 1 << 6,
    RSVG_ASPECT_RATIO_XMID_YMAX = 1 << 7,
    RSVG_ASPECT_RATIO_XMAX_YMAX = 1 << 8,
    RSVG_ASPECT_RATIO_SLICE = 1 << 31
}

/* This one is semi-public for mis-use in rsvg-convert */
int	    rsvg_css_parse_color        (const char *str, bool * inherit);

enum RsvgSizeType {
    ZOOM,
    WH,
    WH_MAX,
    ZOOM_MAX
}

struct RsvgSizeCallbackData {
    RsvgSizeType type;
    double x_zoom;
    double y_zoom;
    int width;
    int height;

    bool keep_aspect_ratio;
}

void _rsvg_size_callback (int *width, int *height, void* data);

bool rsvg_handle_render_cairo     (RsvgHandle * handle, cairo_t * cr);
bool rsvg_handle_render_cairo_sub (RsvgHandle * handle, cairo_t * cr, const char *id);

void rsvg_term();

}
