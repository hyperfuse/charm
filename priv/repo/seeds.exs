# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
#
vcards = VCardParser.parse_file("data.vcf")
simple_vcards = Enum.map(vcards, &VCardParser.simplify/1)

Enum.map(simple_vcards, fn x ->
  Charm.Repo.insert!(%Charm.Contact{first_name: x[:first_name], last_name: x[:last_name]})
end)
