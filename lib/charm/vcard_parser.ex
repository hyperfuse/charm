defmodule VCardParser do
  @moduledoc """
  A module for parsing vCard files in Elixir.
  """

  @doc """
  Parses a vCard file and returns a list of vCard maps.
  Each vCard map contains the parsed properties of a vCard entry.
  """
  def parse_file(file_path) do
    case File.read(file_path) do
      {:ok, content} -> parse_content(content)
      {:error, reason} -> {:error, "Failed to read file: #{reason}"}
    end
  end

  @doc """
  Parses vCard content string and returns a list of vCard maps.
  """
  def parse_content(content) do
    content
    |> String.split("BEGIN:VCARD")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&parse_vcard/1)
    |> Enum.filter(&(&1 != nil))
  end

  defp parse_vcard(vcard_text) do
    # Make sure the vCard ends properly
    case String.contains?(vcard_text, "END:VCARD") do
      true ->
        vcard_text
        |> String.split("\n")
        |> Enum.filter(&(&1 != ""))
        |> Enum.map(&String.trim/1)
        |> Enum.filter(&(&1 != "END:VCARD"))
        |> Enum.reduce(%{}, fn line, acc ->
          parse_line(line, acc)
        end)

      false ->
        nil
    end
  end

  defp parse_line(line, acc) do
    case String.split(line, ":", parts: 2) do
      [key, value] ->
        # Handle properties with parameters
        {property, params} = parse_property(key)

        # Add the property to the accumulator
        Map.put(acc, property, %{value: value, params: params})

      _ ->
        acc
    end
  end

  defp parse_property(key) do
    case String.split(key, ";") do
      [property | params] ->
        # Parse parameters
        params_map = parse_params(params)
        {property, params_map}

      _ ->
        {key, %{}}
    end
  end

  defp parse_params(params) do
    params
    |> Enum.reduce(%{}, fn param, acc ->
      case String.split(param, "=", parts: 2) do
        [key, value] -> Map.put(acc, key, value)
        _ -> acc
      end
    end)
  end

  @doc """
  Extracts a specific property from a parsed vCard.
  """
  def get_property(vcard, property) do
    case Map.get(vcard, property) do
      %{value: value} -> value
      _ -> nil
    end
  end

  @doc """
  Parses the N (name) property and returns a map with name components.
  The N property typically has the format: last;first;middle;prefix;suffix
  """
  def parse_name(vcard) do
    case get_property(vcard, "N") do
      nil ->
        # If N property is missing, try to use FN property
        full_name = get_property(vcard, "FN")
        parse_full_name(full_name)

      name_str ->
        # Parse the N property components
        [last, first, middle, prefix, suffix] =
          (String.split(name_str, ";", parts: 5) ++ ["", "", "", ""])
          |> Enum.take(5)
          |> Enum.map(&String.trim/1)

        %{
          first_name: first,
          last_name: last,
          middle_name: middle,
          prefix: prefix,
          suffix: suffix
        }
    end
  end

  # Helper function to extract first and last name from a full name
  defp parse_full_name(nil), do: %{first_name: "", last_name: ""}

  defp parse_full_name(full_name) do
    parts = String.split(full_name, " ")

    case parts do
      [first, last | _rest] ->
        %{first_name: first, last_name: last}

      [name] ->
        %{first_name: name, last_name: ""}

      [] ->
        %{first_name: "", last_name: ""}
    end
  end

  @doc """
  Extracts common properties from a parsed vCard and returns them in a simplified format.
  """
  def simplify(vcard) do
    name_components = parse_name(vcard)

    %{
      first_name: name_components.first_name,
      last_name: name_components.last_name,
      full_name: get_property(vcard, "FN"),
      email: get_property(vcard, "EMAIL"),
      phone: get_property(vcard, "TEL"),
      organization: get_property(vcard, "ORG"),
      title: get_property(vcard, "TITLE"),
      address: get_property(vcard, "ADR")
    }
  end
end
