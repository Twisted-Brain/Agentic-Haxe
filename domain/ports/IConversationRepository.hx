package domain.ports;

import shared.domain.entities.Conversation;
import shared.core.Result;

/**
 * Repository interface for conversation persistence operations
 */
interface IConversationRepository {
    /**
     * Save a conversation to the repository
     * @param conversation The conversation to save
     * @return Result containing the saved conversation or error message
     */
    function save(conversation: Conversation): Result<Conversation, String>;
    
    /**
     * Find a conversation by its ID
     * @param id The conversation ID
     * @return Result containing the conversation or error message
     */
    function findById(id: String): Result<Conversation, String>;
    
    /**
     * Find all conversations for a specific user
     * @param userId The user ID
     * @return Result containing array of conversations or error message
     */
    function findByUserId(userId: String): Result<Array<Conversation>, String>;
    
    /**
     * Delete a conversation by its ID
     * @param id The conversation ID
     * @return Result indicating success or error message
     */
    function deleteById(id: String): Result<Void, String>;
    
    /**
     * Update an existing conversation
     * @param conversation The conversation to update
     * @return Result containing the updated conversation or error message
     */
    function update(conversation: Conversation): Result<Conversation, String>;
}