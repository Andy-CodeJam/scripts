
from sentence_transformers import SentenceTransformer

def load_model(model_name: str = 'all-MiniLM-L6-v2') -> SentenceTransformer:
    """
    Load the SentenceTransformer model.

    Parameters
    ----------
    model_name : str
        The name of the model to load.

    Returns
    -------
    SentenceTransformer
        The loaded model.
    """
    return SentenceTransformer(model_name)

def embed_text(model: SentenceTransformer, text: str) -> list:
    """
    Embed a given text into a vector.

    Parameters
    ----------
    model : SentenceTransformer
        The loaded SentenceTransformer model.
    text : str
        The text to be embedded.

    Returns
    -------
    list
        The embedded text as a vector.
    """
    return model.encode(text).tolist()

def test_embed_text():
    """
    Test the embed_text function to ensure it returns a vector of the correct length.
    """
    model = load_model()
    text = "This is a test sentence."
    vector = embed_text(model, text)
    assert isinstance(vector, list), "The result should be a list."
    assert len(vector) == 384, "The length of the vector should be 384 for the all-MiniLM-L6-v2 model."

if __name__ == "__main__":
    # Example usage
    model = load_model()
    text = "This is a test sentence."
    vector = embed_text(model, text)
    print(f"Vector for '{text}':\n{vector}")

    # Run the test
    pytest.main([__file__])
