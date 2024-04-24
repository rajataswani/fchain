// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FeedbackSystem {
    // Struct to store feedback details
    struct Feedback {
        address sender; // address of the sender (student)
        string message; // feedback message
        bool resolved; // flag to indicate if feedback is resolved
    }

    // Mapping to store feedbacks
    mapping(uint256 => Feedback) public feedbacks;
    uint256 public feedbackCount;

    // Event to log feedback submission
    event FeedbackSubmitted(uint256 indexed id, address indexed sender, string message);

    // Event to log feedback resolution
    event FeedbackResolved(uint256 indexed id);

    // Modifier to restrict access to admin only
    modifier onlyAdmin() {
        require(msg.sender == adminAddress, "Only admin can perform this action");
        _;
    }

    address public adminAddress;

    constructor() {
        adminAddress = msg.sender; // Set contract creator as admin
    }

    // Function to submit feedback
    function submitFeedback(string memory _message) public {
        feedbackCount++;
        feedbacks[feedbackCount] = Feedback(msg.sender, _message, false);
        emit FeedbackSubmitted(feedbackCount, msg.sender, _message);
    }

    // Function to mark feedback as resolved by ID
    function resolveFeedback(uint256 _id) public onlyAdmin {
        require(_id <= feedbackCount && _id > 0, "Invalid feedback ID");
        feedbacks[_id].resolved = true;
        emit FeedbackResolved(_id);
    }

    // Function to post positive feedback or resolved negative feedback onto a public page
    function postFeedback(uint256 _id) public onlyAdmin {
        require(_id <= feedbackCount && _id > 0, "Invalid feedback ID");
        Feedback memory feedback = feedbacks[_id];
        require(feedback.resolved || isPositiveFeedback(feedback.message), "Feedback not resolved or not positive");
        // Implement your logic to post feedback on public page
        // This could involve emitting an event, storing the feedback somewhere, etc.
    }

    // Function to check if feedback is positive
    function isPositiveFeedback(string memory _message) internal pure returns (bool) {
        // Implement your logic to determine if feedback is positive
        // This is just a placeholder, you may want to enhance this logic
        // based on your specific requirements
        return bytes(_message).length < 100;
    }

    // Function to get feedback count
    function getFeedbackCount() public view returns (uint256) {
        return feedbackCount;
    }

    // Function to get feedback details by ID
    function getFeedback(uint256 _id) public view returns (address, string memory, bool) {
        require(_id <= feedbackCount && _id > 0, "Invalid feedback ID");
        Feedback memory feedback = feedbacks[_id];
        return (feedback.sender, feedback.message, feedback.resolved);
    }
}
