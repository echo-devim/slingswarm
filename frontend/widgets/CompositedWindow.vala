namespace ElementaryWidgets {

    public class CompositedWindow : Gtk.Window {
    
        construct {
        
            //Window properties
            this.skip_taskbar_hint = true;
            this.decorated = false; // no window decoration
            this.app_paintable = true;
            
            this.set_default_colormap (this.get_screen ().get_rgba_colormap () ?? this.get_screen ().get_rgb_colormap ());
            
            this.expose_event.connect (clear_background);
            this.realize.connect (() => {
				this.get_window ().set_back_pixmap (null, false); // transparent background
			});
        
        }
        
        public bool clear_background (Gtk.Widget widget, Gdk.EventExpose event) {
			var context = Gdk.cairo_create (widget.window);
			
			context.set_operator (Cairo.Operator.CLEAR);
			context.paint();
			
			return false;
		}
    
    }
    
}
