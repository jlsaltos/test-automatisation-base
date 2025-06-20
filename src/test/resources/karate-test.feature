Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'

  Scenario: Flujo exitoso: GET → POST → PUT → DELETE
    # GET
    Given url baseUrl
    When method get
    Then status 200
    And match response[0].name == "#string"

    # POST
    Given url baseUrl
    And request
    """
    {
      "name": "Iron Man1916",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    When method post
    Then status 201
    * def createdId = response.id
    * print 'Created ID:', createdId

    # PUT
    Given url baseUrl + '/' + createdId
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

     # DELETE
    Given url baseUrl + '/' + createdId
    When method delete
    Then status 204

  Scenario: Verificar que el endpoint responde correctamente cuando el recurso NO EXISTE

  # GET
    Given url baseUrl + '/999'
    When method get
    Then status 404
    And match response.error == "Character not found"

    # POST (datos duplicados)
    Given url baseUrl
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Otro",
      "description": "Otro",
      "powers": ["Armor"]
    }
    """
    When method post
    Then status 400
    And match response.error == "Character name already exists"

    # PUT
    Given url baseUrl + '/999'
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """
    When method put
    Then status 404
    And match response.error == "Character not found"

  # DELETE
    Given url baseUrl + '/999'
    When method delete
    Then status 404
    And match response.error == "Character not found"

  Scenario: Verificar que el endpoint responde correctamente cuando faltan campos en la creación de un personaje
    Given url baseUrl
    And request
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    When method post
    Then status 400
    And match response.name == "Name is required"
    And match response.description == "Description is required"
    And match response.powers == "Powers are required"
    And match response.alterego == "Alterego is required"

  Scenario: Verificar que el endpoint lista todos los elementos
    Given url baseUrl
    When method get
    Then status 200
    And match response == '#[]'
    * print 'Response:', response
