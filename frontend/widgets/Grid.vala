
namespace Slingshot.Frontend {

    public class Grid : Gtk.Table {
    
        /*const int FPS = 24;
        const int DURATION = 1000;
        const int RUN_LENGTH = (int)(DURATION/FPS); // total number of frames
        private int CURRENT_FRAME = 1; // run length, in frames*/

        public Grid (int rows, int columns) {
        
            // Table Properties
            this.n_columns = columns;
            this.n_rows = rows;
            this.homogeneous = true;
        
        }
        
        /*public void fade_in () {
        
           GLib.Timeout.add (((int)(1000/this.FPS)), () => {
				if (this.CURRENT_FRAME == this.RUN_LENGTH) {
				    CURRENT_FRAME = 1;
					return false; // stop animation
				}
				this.queue_draw ();
				this.CURRENT_FRAME++;
				return true;
			});
            
        }*/
        
        /*public override bool expose_event (Gdk.EventExpose event) {
            base.expose_event (event);
            var context = Gdk.cairo_create (event.window);
            
            var dim = new Cairo.Pattern.rgba (0.0, 0.0, 0.0, (double)(0.5)/(this.RUN_LENGTH/this.CURRENT_FRAME));
            context.mask (dim);
            
            return true;
        }*/
        
    }
}
