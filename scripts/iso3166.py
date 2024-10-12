import sys
import json
import pycountry
import gettext

# Usage: python iso3166.py ca
# Generates: iso-3166-ca.json
# Requirements: pip install -r requirements.txt

translate_country: gettext.GNUTranslations = None
translate_subdivision: gettext.GNUTranslations = None

def generate_iso_3166_json(language: str):
    """
    Genera un fitxer JSON amb tots els països i les seves regions segons l'estàndard ISO-3166.

    :param language: L'idioma per traduïr els països en el camp `name_{language}` de cada país.
    """
    iso_data = {
        "countries": [],
    }

    # Itera tots els països
    for country in pycountry.countries:
        country_dict = get_country_dict(country, language)

        # Obté les subdivisions (regions) del país
        country_subdivisions = pycountry.subdivisions.get(country_code=country.alpha_2)

        # Filtra les regions principals
        root_subdivisions = filter(lambda sub: sub.parent_code is None, country_subdivisions)

        for parent in root_subdivisions:
            # Afegeix la regió principal
            parent_dict = get_subdivision_dict(parent, language)

            country_dict["subdivisions"].append(parent_dict)

            # Afegeix les regions filles
            add_children_subdivisions(parent_dict, parent, country_subdivisions, language)

        # Afegeix el país amb les subdivisions (regions)
        iso_data["countries"].append(country_dict)

    # Escriu els resultats
    output_file = f"iso-3166-{language}.json"
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(iso_data, f, ensure_ascii=False, indent=2)

    print(f"Created: {output_file}")

def get_country_dict(country: pycountry.db.Country, language: str) -> dict:
    return {
        "name": country.name,
        f"name_{language}": translate_country(country.name),
        "code": country.alpha_2,
        "flag": country.flag,
        "subdivisions": [],
    }

def get_subdivision_dict(subdivision: pycountry.Subdivisions, language: str) -> dict:
    # Divideix el country_code i l'id de la regió
    _, subdivision_id = subdivision.code.split('-', 1)

    return {
        "name": subdivision.name,
        f"name_{language}": translate_subdivision(subdivision.name),
        "code": subdivision.code,
        "id": subdivision_id,
        "type": subdivision.type,
        "subdivisions": []
    }

def add_children_subdivisions(parent_dict: dict, parent: pycountry.Subdivisions, subdivisions: list[pycountry.Subdivisions], language: str):
    # Filtra les regions filles
    children_subdivisions = list(filter(lambda sub: sub.parent_code == parent.code, subdivisions))

    for child in children_subdivisions:
        # Afegeix la regió
        child_dict = get_subdivision_dict(child, language)

        parent_dict["subdivisions"].append(child_dict)

        # Afegeix les regions filles recursivament
        add_children_subdivisions(child_dict, child, children_subdivisions, language)

def install_translations(language: str):
    global translate_country, translate_subdivision

    def clean(s: str):
        return s.rstrip('*')

    def clean_f(translate):
        return lambda s: clean(translate(s))

    if language == 'en':
        translate_country = clean
        translate_subdivision = clean
    else:
        try:
            translate_country = gettext.translation('iso3166-1', pycountry.LOCALES_DIR, languages=[language])
            translate_country = clean_f(translate_country.gettext)
            translate_subdivision = gettext.translation('iso3166-2', pycountry.LOCALES_DIR, languages=[language])
            translate_subdivision = clean_f(translate_subdivision.gettext)
        except FileNotFoundError:
            print(f"Language not found: {language}")
            sys.exit(1)

if __name__ == "__main__":
    # Instal·la les traduccions d'idioma
    language_code = sys.argv[1] if len(sys.argv) > 1 else 'en'
    install_translations(language=language_code)

    # Genera el fitxer JSON amb les dades ISO-3166
    generate_iso_3166_json(language_code)
