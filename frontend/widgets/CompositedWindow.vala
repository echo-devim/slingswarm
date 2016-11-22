namespace ElementaryWidgets {

    public class CompositedWindow : Gtk.Window {
    
        construct {
        
            //Window properties
            this.set_skip_taskbar_hint (true);
            this.set_decorated (false); // no window decoration
            this.set_app_paintable (true);
            this.set_name ("mainwindow");
            
            //this.set_default_colormap (this.get_screen ().get_rgba_colormap () ?? this.get_screen ().get_rgb_colormap ());
            
            this.draw.connect (clear_background);
            this.realize.connect (() => {
                // transparent background
                //source: http://wolfvollprecht.de/blog/gtk-python-and-css-are-an-awesome-combo/
                /*Gtk.CssProvider provider = new Gtk.CssProvider ();
                provider.load_from_data ("window { background-color: #FF0000; }");
                Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default(), provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
                */
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
