defmodule Rauversion.Genres do
  def all() do
    [
      %{
        "genre" => "Ambient",
        "subgenres" => [
          "Ambient Dub",
          "Dark Ambient",
          "Drone",
          "Space Music"
        ]
      },
      %{
        "genre" => "Breakbeat",
        "subgenres" => [
          "Breakcore",
          "Big Beat",
          "Nu Skool Breaks"
        ]
      },
      %{
        "genre" => "Dance",
        "subgenres" => [
          "Acid House",
          "Disco House",
          "Eurodance",
          "Italo Disco",
          "Hi-NRG",
          "Europop"
        ]
      },
      %{
        "genre" => "Drum & Bass",
        "subgenres" => [
          "Jungle",
          "Jump Up",
          "Liquid Funk",
          "Intelligent Drum & Bass",
          "Techstep"
        ]
      },
      %{
        "genre" => "Dubstep",
        "subgenres" => [
          "Brostep",
          "Dub-Influenced",
          "Post-Dubstep"
        ]
      },
      %{
        "genre" => "Electronica",
        "subgenres" => [
          "Glitch",
          "IDM (Intelligent Dance Music)",
          "Trip-Hop",
          "Abstract"
        ]
      },
      %{
        "genre" => "House",
        "subgenres" => [
          "Chicago House",
          "Deep House",
          "Funky House",
          "Garage House",
          "Progressive House",
          "Tech House",
          "Tribal House"
        ]
      },
      %{
        "genre" => "Techno",
        "subgenres" => [
          "Ambient Techno",
          "Detroit Techno",
          "Minimal Techno",
          "Schranz",
          "Hard Techno",
          "Trance Techno"
        ]
      },
      %{
        "genre" => "Trance",
        "subgenres" => [
          "Acid Trance",
          "Classic Trance",
          "Goa Trance",
          "Hard Trance",
          "Progressive Trance",
          "Uplifting Trance"
        ]
      },
      %{
        "genre" => "Avant-Garde",
        "subgenres" => [
          "Free Jazz",
          "Musique Concrète",
          "Free Improvisation",
          "Noise Music"
        ]
      },
      %{
        "genre" => "Industrial",
        "subgenres" => [
          "EBM (Electronic Body Music)",
          "Power Electronics",
          "Rhythmic Noise",
          "Industrial Rock"
        ]
      },
      %{
        "genre" => "Noise",
        "subgenres" => [
          "Harsh Noise",
          "Wall of Sound",
          "Power Electronics"
        ]
      },
      %{
        "genre" => "Sound Art",
        "subgenres" => [
          "Acousmatic Music",
          "Sound Installation",
          "Sound Poetry"
        ]
      },
      %{
        "genre" => "Indie Pop",
        "subgenres" => [
          "Twee Pop",
          "Dream Pop",
          "Jangle Pop"
        ]
      },
      %{
        "genre" => "Indie Rock",
        "subgenres" => [
          "Alternative Rock",
          "Post-Punk",
          "New Wave",
          "Post-Rock",
          "Math Rock",
          "Lo-Fi"
        ]
      },
      %{
        "genre" => "Indie Folk",
        "subgenres" => [
          "Freak Folk",
          "New Weird America",
          "Anti-Folk"
        ]
      },
      %{
        "genre" => "Indie Electronic",
        "subgenres" => [
          "Chillwave",
          "Synthpop",
          "Dream Pop",
          "Indietronica"
        ]
      },
      %{
        "genre" => "Indie Metal",
        "subgenres" => [
          "Math Metal",
          "Post-Metal",
          "Sludge Metal"
        ]
      }
    ]
  end

  def plain() do
    all()
    |> Enum.reduce([], fn el, acc ->
      acc ++ [el["genre"]] ++ el["subgenres"]
    end)
  end
end
