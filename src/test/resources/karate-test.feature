Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'

  Scenario: Verificar que el endpoint de personajes responde 200 y devuelve el JSON esperado
    Given url baseUrl
    When method get
    Then status 200
    And match response[0].name == "#string"

  Scenario: Verificar que el endpoint de personajes permite crear un personaje exitosamente
    Given url baseUrl
    And request
  """
  {
    "name": "Iron Man1911",
    "alterego": "Tony Stark",
    "description": "Genius billionaire",
    "powers": ["Armor", "Flight"]
  }
  """
    When method post
    Then status 201
    And match response.name == "Iron Man1911"
    And match response.alterego == "Tony Stark"
    And match response.description == "Genius billionaire"
    And match response.powers == ["Armor", "Flight"]
    * def createdId = response.id
    * karate.set('createdId', createdId)


  Scenario: Verificar que el endpoint de personajes permite actualizar un personaje usando el id creado
    Given url baseUrl + '/549'
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark X",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """
    When method put
    Then status 200
    And match response.name == "Iron Man"
    And match response.alterego == "Tony Stark X"
    And match response.description == "Updated description"
    And match response.powers == ["Armor", "Flight"]

  Scenario: Verificar que el endpoint de personajes permite eliminar un personaje exitosamente
    Given url baseUrl + '/549'
    When method delete
    Then status 204

