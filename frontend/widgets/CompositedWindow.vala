namespace ElementaryWidgets {

    public class CompositedWindow : Gtk.Window {
    
        construct {
        
            //Window properties
            this.set_skip_taskbar_hint (true);
            this.set_decorated (false); // no window decoration
            this.set_app_paintable (true);
            this.set_name ("mainwindow");
            this.set_visual (this.get_screen().get_rgba_visual ());
            
            //this.set_default_colormap (this.get_screen ().get_rgba_colormap () ?? this.get_screen ().get_rgb_colormap ());
            //Gtk.Window window = this;
            
            this.draw.connect (clear_background);
            this.realize.connect (() => {
                // transparent background
                //var color = Gdk.RGBA ();
                //color.parse ("#a0a0a0");
                //window.override_background_color(Gtk.StateFlags.NORMAL, color);
            });
        
        }
        
        public bool clear_background (Gtk.Widget widget, Cairo.Context ctx) {
            var context = Gdk.cairo_create (widget.get_window ());
            
            context.set_operator (Cairo.Operator.CLEAR);
            context.paint();
            
            return false;
        }
    
    }
    
}
