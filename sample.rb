require 'gtk3'

  COLUMN_ENGLISH, COLUMN_JAPANESE = *(0..1).to_a

  @store = Gtk::ListStore.new(String, String)

  def add_columns(treeview, name, index)
    renderer = Gtk::CellRendererText.new
    column = Gtk::TreeViewColumn.new(name, renderer, 'text' => index)
    column.set_sort_column_id(index)
    treeview.append_column(column)
  end

  def get_fruit(fruit_name)
    data = [
      %w[ apple りんご ],
      %w[ grape ぶどう ],
      %w[ banana ばなな ],
      %w[ orange おれんじ ],
    ]
    data.select!{|x| x[1] == fruit_name}

    @store.clear

    data.each do |item|
      iter = @store.append
      item.each_with_index do |value, index|
        iter[index] = value
      end
    end
  end

  combo = Gtk::ComboBoxText.new
  %w[りんご ぶどう おれんじ ばなな].each do |label|
    combo.append_text(label)
  end
  combo.signal_connect("changed") do |widget|
    get_fruit(widget.active_text)
  end



  treeview = Gtk::TreeView.new(@store)
  treeview.rules_hint = true
  treeview.search_column = COLUMN_JAPANESE

  add_columns(treeview, '英語', COLUMN_ENGLISH)
  add_columns(treeview, '日本語', COLUMN_JAPANESE)

  sw = Gtk::ScrolledWindow.new(nil, nil)
  sw.shadow_type = :etched_in
  sw.set_policy(:never, :automatic)
  sw.add(treeview)

  box = Gtk::VBox.new(false, 8)
  box.pack_start(Gtk::Label.new('GUIアプリ'), false, false, 0)
  box.pack_start(combo, false, false, 0)
  box.pack_start(sw, true, true, 0)


  window = Gtk::Window.new
  window.add(box)
  window.set_default_size(640, 480)
  window.show_all
  window.signal_connect("destroy") { Gtk.main_quit }

  Gtk.main
