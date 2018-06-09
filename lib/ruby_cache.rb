
[12] pry(main)> l = { "languages" => {"english" => "eng", "german" => "deu", "finish" => "fsh"} } => {"languages"=>{"english"=>"eng", "german"=>"deu", "finish"=>"fsh"}}
[13] pry(main)> Rails.cache.write('authorities_cache', l) # => true
[14] pry(main)> Rails.cache.fetch('authorities_cache') # => {"languages"=>{"english"=>"eng", "german"=>"deu", "finish"=>"fsh"}}
[15] pry(main)> Rails.cache.fetch('authorities_cache')['languages'] # => {"english"=>"eng", "german"=>"deu", "finish"=>"fsh"}
[16] pry(main)> Rails.cache.fetch('authorities_cache')['languages']['english'] # => "eng"