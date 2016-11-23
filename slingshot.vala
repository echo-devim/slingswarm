public class SlingshotWindow : ElementaryWidgets.CompositedWindow {

    public GLib.List<Slingshot.Frontend.AppItem> children = new GLib.List<Slingshot.Frontend.AppItem> ();
    public Slingshot.Frontend.Searchbar searchbar;
    public Gtk.Grid grid;
    
    public Gee.ArrayList<Gee.HashMap<string, string>> apps = new Gee.ArrayList<Gee.HashMap<string, string>> ();
    public Gee.HashMap<string, Gdk.Pixbuf> icons = new Gee.HashMap<string, Gdk.Pixbuf>();
    public Gee.ArrayList<Gee.HashMap<string, string>> filtered = new Gee.ArrayList<Gee.HashMap<string, string>> ();
    
    public Slingshot.Frontend.Indicators pages;
    public Slingshot.Frontend.Indicators categories;
    public Gee.ArrayList<GMenu.TreeDirectory> all_categories = Slingshot.Backend.GMenuEntries.get_categories ();
    public int icon_size;
    public int total_pages;
    public Gtk.Box top_spacer;

    private int grid_x;
    private int grid_y;
    
    public SlingshotWindow () {
    
        // Show desktop
        Wnck.Screen.get_default().toggle_showing_desktop (false);
        
        // Window properties
        this.set_title ("Slingscold");
        this.set_skip_pager_hint (true);
        this.set_skip_taskbar_hint (true);
        this.set_type_hint (Gdk.WindowTypeHint.NORMAL);
        this.fullscreen (); //this.maximize ();
        this.stick ();
        this.set_keep_above (true);
        
        // Set icon size
        Gdk.Rectangle monitor_dimensions;
        Gdk.Screen screen = Gdk.Screen.get_default();
        screen.get_monitor_geometry(screen.get_primary_monitor(), out monitor_dimensions);
        
        double suggested_size = (Math.pow (monitor_dimensions.width * monitor_dimensions.height, ((double) (1.0/3.0))) / 1.6);
        if (suggested_size < 27) {
            this.icon_size = 24;
        } else if (suggested_size >= 27 && suggested_size < 40) {
            this.icon_size = 32;
        } else if (suggested_size >= 40 && suggested_size < 56) {
            this.icon_size = 48;
        } else if (suggested_size >= 56) {
            this.icon_size = 64;
        }
        
        // Get all apps
        Slingshot.Backend.GMenuEntries.enumerate_apps (Slingshot.Backend.GMenuEntries.get_all (), this.icons, this.icon_size, out this.apps);
        
        // Add container wrapper
        var wrapper = new Gtk.EventBox (); // used for the scrolling and button press events
        wrapper.set_visible_window (false);
        this.add (wrapper);
        
        // Add container
        var container = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        wrapper.add (container);
         
        // Add top bar
        var top = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        var bottom = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        
        this.categories = new Slingshot.Frontend.Indicators ();
        this.categories.child_activated.connect (this.change_category);
        this.categories.append ("All");
        foreach (GMenu.TreeDirectory category in this.all_categories) {
            this.categories.append (category.get_name ());
        }
        
        //category appllication
        this.categories.set_active (0);
        top.pack_start (this.categories, true, true, 20);
       
        this.top_spacer = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);
        this.top_spacer.realize.connect ( () => { this.top_spacer.visible = true; } );
        this.top_spacer.can_focus = true;
        bottom.pack_start (this.top_spacer, false, false, 0);
        
        //searchbar
        this.searchbar = new Slingshot.Frontend.Searchbar ("Type to search...");
        this.searchbar.changed.connect (this.search);
        //jarak samping
        int medio = (monitor_dimensions.width / 2) - 120; //place the search bar in the center of the screen
        bottom.pack_start (this.searchbar, false, true, medio);
        
        //jarak atas 
        container.pack_start (bottom, false, true, 20); 
        container.pack_start (top, false, true, 0); 
        
        this.grid = new Gtk.Grid();
        this.grid.set_row_spacing (70);
        this.grid.set_column_spacing (30);
        // Make icon grid and populate
        if (monitor_dimensions.width > monitor_dimensions.height) { // normal landscape orientation
            //Slingshot.Frontend.Grid (4, 6);
            this.grid_x = 4;
            this.grid_y = 6;
        } else { // most likely a portrait orientation
            //Slingshot.Frontend.Grid (6, 4);
            this.grid_x = 6;
            this.grid_y = 4;
        }
        // Initialize the grid
        for (int r = 0; r < this.grid_x; r++)
            this.grid.insert_row(r);
        for (int c = 0; c < this.grid_y; c++)
            this.grid.insert_column(c);
        
        container.pack_start (this.grid, true, true, 0);
        
        this.populate_grid ();
        
        // Add pages
        this.pages = new Slingshot.Frontend.Indicators ();
        this.pages.child_activated.connect ( () => { this.update_grid (this.filtered); } );
        
        var pages_wrapper = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
        pages_wrapper.set_size_request (-1, 30);        
        container.pack_end (pages_wrapper, false, true, 15);
        
        // Find number of pages and populate
        this.update_pages (this.apps);
        if (this.total_pages >  1) {
            pages_wrapper.pack_start (this.pages, true, false, 0);
            for (int p = 1; p <= this.total_pages; p++) {
                this.pages.append (p.to_string ());
            } 
        }
        this.pages.set_active (0);
        
        // Signals and callbacks
        this.button_release_event.connect ( () => { this.destroy(); return false; });
        this.draw.connect (this.draw_background);
        this.focus_out_event.connect ( () => { this.destroy(); return true; } ); // close slingshot when the window loses focus
    }
    
    private void populate_grid () {        
    
        for (int r = 0; r < this.grid_x; r++) {
            
            for (int c = 0; c < this.grid_y; c++) {
                            
                var item = new Slingshot.Frontend.AppItem (this.icon_size);
                this.children.append (item);
                
                item.button_press_event.connect ( () => { item.grab_focus (); return true; } );
                item.enter_notify_event.connect ( () => { item.grab_focus (); return true; } );
                item.leave_notify_event.connect ( () => { this.top_spacer.grab_focus (); return true; } );
                item.button_release_event.connect ( () => {
                    
                    try {
                        new GLib.DesktopAppInfo.from_filename (this.filtered.get((int) (this.children.index(item) + (this.pages.active * this.grid_y * this.grid_x)))["desktop_file"]).launch (null, null);
                        this.destroy();
                    } catch (GLib.Error e) {
                        stdout.printf("Error! Load application: " + e.message);
                    }
                    
                    return true;
                    
                });
                
                this.grid.attach (item, c, r);
                
            } 
        }        
    }
    
    private void update_grid (Gee.ArrayList<Gee.HashMap<string, string>> apps) {    
        
        int item_iter = (int)(this.pages.active * this.grid_y * this.grid_x);
        for (int r = 0; r < this.grid_x; r++) {
            
            for (int c = 0; c < this.grid_y; c++) {
                
                int table_pos = c + (r * (int)this.grid_y); // position in table right now
                
                var item = this.children.nth_data(table_pos);
                if (item_iter < apps.size) {
                    var current_item = apps.get(item_iter);
                    
                    // Update app
                    if (current_item["description"] == null || current_item["description"] == "") {
                        item.change_app (icons[current_item["command"]], current_item["name"], current_item["name"]);
                    } else {
                        item.change_app (icons[current_item["command"]], current_item["name"], current_item["name"] + ":\n" + current_item["description"]);
                    }
                    item.visible = true;

                } else { // fill with a blank one
                    item.visible = false;
                }
                
                item_iter++;
                
            }
        }
        
        // Update number of pages
        this.update_pages (apps);
        
        // Grab first one's focus
        this.children.nth_data (0).grab_focus ();
    }
    
    private void change_category () {
        this.filtered.clear ();
        
        if (this.categories.active != 0) {
            Slingshot.Backend.GMenuEntries.enumerate_apps (Slingshot.Backend.GMenuEntries.get_applications_for_category (this.all_categories.get (this.categories.active - 1)), this.icons, this.icon_size, out this.filtered);
        } else {
            this.filtered.add_all (this.apps);
        }
        
        this.pages.set_active (0); // go back to first page in category
    }
    
    private void update_pages (Gee.ArrayList<Gee.HashMap<string, string>> apps) {
        // Find current number of pages and update count
        var num_pages = (int) (apps.size / (this.grid_y * this.grid_x));
        (double) apps.size % (double) (this.grid_y * this.grid_x) > 0 ? this.total_pages = num_pages + 1 : this.total_pages = num_pages;
        
        // Update pages
        if (this.total_pages > 1) {
            this.pages.visible = true;
            for (int p = 1; p <= this.pages.children.length (); p++) {
                p > this.total_pages ? this.pages.children.nth_data (p - 1).visible = false : this.pages.children.nth_data (p - 1).visible = true;
            }
        } else {
            this.pages.visible = false;
        }
        
    }
    
    private void search() {
        
        var current_text = this.searchbar.text.down ();
        
        this.categories.set_active_no_signal (0); // switch to first page
        this.filtered.clear ();
        
        foreach (Gee.HashMap<string, string> app in this.apps) {
            if (current_text in app["name"].down () || current_text in app["description"].down () || current_text in app["command"].down ()) {
                this.filtered.add (app);
            }
        }     
        
        this.pages.set_active (0);   
        
        this.queue_draw ();
    }
    
    private void page_left() {
        
        if (this.pages.active >= 1) {
            this.pages.set_active (this.pages.active - 1);
        }
        
    }
    
    private void page_right() {
        
        if ((this.pages.active + 1) < this.total_pages) {
            this.pages.set_active (this.pages.active + 1);
        }
        
    }

    private bool draw_background (Gtk.Widget widget, Cairo.Context ctx) {
        Gtk.Allocation size;
        widget.get_allocation (out size);
        var context = Gdk.cairo_create (widget.get_window ());

        // Semi-dark background
        var linear_gradient = new Cairo.Pattern.linear (size.x, size.y, size.x, size.y + size.height);
        linear_gradient.add_color_stop_rgba (0.0, 0.0, 0.0, 0.0, 1);
        linear_gradient.add_color_stop_rgba (0.50, 0.0, 0.0, 0.0, 0.85);
        linear_gradient.add_color_stop_rgba (0.99, 0.0, 0.0, 0.0, 0.50);
                
        context.set_source (linear_gradient);
        context.paint ();
        
        return false;
    }
    
    // Keyboard shortcuts
    public override bool key_press_event (Gdk.EventKey event) {
        switch (Gdk.keyval_name (event.keyval)) {
        
            case "Escape":
                this.destroy ();
                return true;
            case "ISO_Left_Tab":
                this.page_left ();
                return true;
            case "Shift_L":
            case "Shift_R":
                return true;
            case "Tab":
                this.page_right ();
                return true;
            case "Return":
                if (this.filtered.size >= 1) {
                    this.get_focus ().button_release_event ((Gdk.EventButton) new Gdk.Event (Gdk.EventType.BUTTON_PRESS));
                }
                return true;
            case "BackSpace":
                this.searchbar.text = this.searchbar.text.slice (0, (int) this.searchbar.text.length - 1);
                return true;
            case "Left":
                var current_item = this.grid.get_children ().index (this.get_focus ());
                if (current_item % this.grid_y == this.grid_y - 1) {
                    this.page_left ();
                    return true;
                }
                break;
            case "Right":
                var current_item = this.grid.get_children ().index (this.get_focus ());
                if (current_item % this.grid_y == 0) {
                    this.page_right ();
                    return true;
                }
                break;
            case "Down":
            case "Up":
                break; // used to stop refreshing the grid on arrow key press
            default:
                this.searchbar.text = this.searchbar.text + event.str;
                break;
        }
        
        base.key_press_event (event);
        return false;
        
    }
    
    // Scrolling left/right for pages
    public override bool scroll_event (Gdk.EventScroll event) {
        switch (event.direction.to_string()) {
        
            case "GDK_SCROLL_UP":
            case "GDK_SCROLL_LEFT":
                this.page_left ();
                break;
            case "GDK_SCROLL_DOWN":
            case "GDK_SCROLL_RIGHT":
                this.page_right ();
                break;
        
        }
                
        return false;
    }
    
    // Override destroy for fade out and stuff
    public new void destroy () {
        // Restore windows
        Wnck.Screen.get_default ().toggle_showing_desktop (false);
        
        base.destroy();
        Gtk.main_quit();
    }
    
}

int main (string[] args) {

	Gtk.init (ref args);

	Unique.App app = new Unique.App ("org.elementary.slingshot", null);
	
	if (app.is_running ()) { //close if already running
		Unique.Command command = Unique.Command.NEW;
		app.send_message (command, new Unique.MessageData());
	} else {
        
		var main_win = new SlingshotWindow ();
		main_win.show_all ();
		
		app.watch_window (main_win);
		
		Gtk.main ();
	}
	
	return 1;
	
}

